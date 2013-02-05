class PartnerSiteCategory < ActiveRecord::Base

  belongs_to :partner_site
  has_many :partner_site_categories_quiz_categories, :foreign_key => :partner_site_category_id
  has_many :quiz_categories, :through => :partner_site_categories_quiz_categories

end
