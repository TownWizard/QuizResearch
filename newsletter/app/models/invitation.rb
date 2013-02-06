class Invitation < ActiveRecord::Base
  attr_accessor :recipient_email1, :recipient_email2, :recipient_email3, :recipient_email4, :recipient_email5, :newsletter

  belongs_to :sender, :class_name => 'Subscriber'
  has_one :recipient, :class_name => 'Subscriber'

  validates_presence_of :recipient_email
  validate :recipient_is_not_registered
#  validates_uniqueness_of :sender_id, :scope => :recipient_email
#  validate :sender_has_invitations, :if => :sender

  before_create :generate_token
#  before_create :decrement_sender_count, :if => :sender

  def self.send_multiple(params, sender_id, newsletter)
    count = 0
    5.times do |i|
      params[:recipient_email]  = params["recipient_email#{i+1}".to_sym]
      begin
        next if params[:recipient_email].blank?
        invitation = self.new(:recipient_email => params[:recipient_email], :sender_id => sender_id, :newsletter => newsletter)

        if invitation.save!
          Subscriber.create!(:email => params[:recipient_email], :inviting => true)  if Subscriber.find_by_email(params[:recipient_email]).nil?
          Mailer.deliver_invitation(invitation, newsletter)
          count += 1
        end
      rescue
        next
      end
    end
    return count
  end

  private

  def recipient_is_not_registered
    subscriber = Subscriber.find_by_email(recipient_email)
    if subscriber && subscriber.opted_in_to?(newsletter)
      errors.add :recipient_email, 'is already registered'
    end
  end

  def sender_has_invitations
    unless sender.invitation_limit > 0
      errors.add_to_base 'You have reached your limit of invitations to send.'
    end
  end

  def generate_token
    self.token = Digest::SHA1.hexdigest([Time.now, rand].join)
  end

#  def decrement_sender_count
#    sender.decrement! :invitation_limit
#  end
end
