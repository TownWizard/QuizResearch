class Subscriber < ActiveRecord::Base
  attr_accessor :inviting
  has_many :newsletter_subscriptions
  has_many :newsletters, :through => :newsletter_subscriptions

  has_many :sent_invitations, :class_name => 'Invitation', :foreign_key => 'sender_id'
  belongs_to :invitation

  validates_presence_of :email
  validates_presence_of :first_name, :last_name, :unless => Proc.new {|p| p.inviting}
  validates_length_of :email, :within => 6..100, :if => :email?
  validates_uniqueness_of :email, :case_sensitive => false, :if => :email?
  validates_format_of :email, :with => /^[A-Z0-9_\.%\+\-]+@(?:[A-Z0-9\-]+\.)+(?:[A-Z]{2,4}|museum|travel)$/i, :if => :email?

  def subscribed_to?(newsletter)
    newsletter_ids.include?(newsletter.id)
  end

  def opted_in_to?(newsletter)
    subscription_in(newsletter).opt_in == true
  end

  def subscription_in(newsletter)
    newsletter_subscriptions.find_by_newsletter_id(newsletter)
  end

  def invitation_token
    invitation.token if invitation
  end

  def invitation_token=(token)
    self.invitation = Invitation.find_by_token(token)
  end
end
