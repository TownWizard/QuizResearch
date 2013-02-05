class PartnerSite < ActiveRecord::Base
  belongs_to :partner
  has_many :shared_quizzes
  has_many :quizzes, :through => :shared_quizzes
  has_many :users
  has_many :partner_site_categories
  #has_many :partner_site_categories_quiz_categories, :through => :partner_site_categories
  #has_many :partner_site_categories_quiz_categories
  #has_many :quiz_categories, :through => :partner_site_categories_quiz_categories

  validates_presence_of     :key, :host, :domain, :display_name

  validates_length_of       :key,    :within => 3..50
  validates_length_of       :host,    :within => 3..50
  validates_length_of       :domain,    :within => 4..255
  validates_length_of       :display_name,    :within => 4..255

  def identifier
    "#{host}.#{domain}"
  end

end
