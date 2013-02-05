#require 'digest/sha1'

class User < ActiveRecord::Base
  
  acts_as_authentic do |c|
    c.transition_from_restful_authentication = true
    #c.validate_login_field false
    #c.validate_email_field
  end

  belongs_to    :user_type
  belongs_to    :partner_site
  
  belongs_to    :partner  # stupidly, this is the admin partner.  it has
                          #nothing to do with partner_site partner, since
                          #partner_site is only for acquired customers.

  has_many      :quiz_instances
  has_many      :user_quiz_answers
  has_and_belongs_to_many :roles

  before_save :add_user_role

  #validates_format_of       :name_first,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  #validates_length_of       :name_first,     :maximum => 100
  
  #validates_format_of       :name_last,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  #validates_length_of       :name_last,     :maximum => 100

 #before_create :make_activation_code

  # NOTE by GMC, 04 08 2010
  # The below comment and attr_accessible call could be completely vestigial.
  #
  # Do go ahead and read the above note.
  # 
  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :password, :password_confirmation,
    :dob_confirmed, :name_first, :name_last, :last_login, :partner_id


  # Activates the user in the database.
  def activate!
    @activated = true
    self.activated_at = Time.now.utc
    self.activation_code = nil
    save(false)
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end

  def active?
    # the existence of an activation code means they have not activated yet
    activation_code.nil?
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  # has_role? simply needs to return true or false whether a user has a role or not.
  def has_role?(role_in_question)
    @_list ||= self.roles.collect(&:name)
    (@_list.include?(role_in_question.to_s) )
  end

  # returns a collection of partner sites to which this user has access
  def authorized_partner_sites
    if has_role? 'admin'
      sites = PartnerSite.all
    else
      sites =
        PartnerSite.all :conditions => [ 'partner_id = ?', partner_id ]
    end
    sites
  end
  
  # check to see if this user is authorized for this partner site
  def authorized_for_partner_site? ( site_needed )
    if authorized_partner_sites.detect{ |site| site.id == site_needed.id } != nil
      true
    else
      false
    end
  end

  # this is intended for use as a before_save callback to make sure every user has a
  # default user role.
  def add_user_role
    user_role = Role.find_by_name("user")
    self.roles << user_role if user_role and self.roles.empty?
  end
  
#  protected
#
#    def make_activation_code
#        self.activation_code = self.class.make_token
#    end


end
