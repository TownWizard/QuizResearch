class PartnerSiteCategoriesQuizCategory < ActiveRecord::Base

  belongs_to :quiz_category, :foreign_key => :quiz_category_id
  belongs_to :partner_site_category, :foreign_key => :partner_site_category_id

end
