class Publishers::PartnerSiteCategoriesController < Publishers::BaseController
  layout 'publishers'
  skip_before_filter :verify_authenticity_token
  before_filter :authorize_site_admin_access
  
  def create
    PartnerSiteCategory.create! params[ :partner_site_category ]
    flash[ :notice ] = "Partner Site Category Created Successfully."
    redirect_to "/publishers/partner_site_categories" and return
  end

  def destroy
  end

  def edit
    @partner_site_category = PartnerSiteCategory.find params[ :id ]
    @current_partner_id = @partner_site_category.partner_site.partner_id
    if current_user.has_role? 'admin'      
      @partner_sites = PartnerSite.all :conditions => [ 'partner_id = ?', @current_partner_id ]
    else
      @partner_sites = current_user.authorized_partner_sites
    end
  end

  def index
    if current_user.has_role? 'admin'
      @partner_site_category = PartnerSiteCategory.all
    else
      @partner_site_category = PartnerSiteCategory.all(
        :conditions => [ "partners.id = ?", current_user.partner.id ],
        :joins => { :partner_site => :partner }
      )
    end
  end
  
  def new
    @partner_site_category = PartnerSiteCategory.new
    if current_user.has_role? 'admin'
      @current_partner_id = Partner.find(:first).id
      @partner_sites = PartnerSite.all :conditions => [ 'partner_id = ?', @current_partner_id ]
    else
      @current_partner_id = current_user.partner.id
      @partner_sites = current_user.authorized_partner_sites
    end
  end

  def update
    @partner_site_category = PartnerSiteCategory.find params[ :id ]
    @partner_site_category.update_attributes( params[ :partner_site_category ])
    flash[ :notice ] = "Partner Site Category Updated Successfully."
    redirect_to "/publishers/partner_site_categories" and return
  end

  def show
    @partner_site_category = PartnerSiteCategory.find params[ :id ]
  end

  def select_partner_site_list
    @partner_sites = PartnerSite.all :conditions => [ 'partner_id = ?', params[:current_partner_id] ]
    @curr_sel_site=@partner_sites.size>0?@partner_sites[0].id : 0
    render :partial => 'partner_site_select', :layout => false
  end

  def show_quiz_categories
    @partner_site_category = PartnerSiteCategory.find params[ :id ]
    @quiz_categories = QuizCategory.all
  end

  def save
    @partner_site_category = PartnerSiteCategory.find params[ :id ]
    @quiz_category = QuizCategory.find(params[:quiz_category])
    if params[:show] == "true"
      @partner_site_category.quiz_categories << @quiz_category
    else
      @partner_site_category.quiz_categories.delete(@quiz_category)
    end
    @partner_site_category.save!
    render :nothing => true
  end

end
