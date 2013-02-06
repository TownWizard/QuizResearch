class Publishers::PartnerSitesController < Publishers::BaseController
  layout 'publishers'
  skip_before_filter :verify_authenticity_token
  before_filter :authorize_site_admin_access
  
  def create
    PartnerSite.create! params[ :partner_site ]
    flash[ :notice ] = "Partner Site Created Successfully."
    redirect_to "/publishers/partner_sites" and return
  end

  def destroy
  end

  def edit
    @partner_site = PartnerSite.find params[ :id ]
  end

  def index
    if current_user.has_role? 'admin'
      @partner_sites = PartnerSite.all(
        :conditions => 'partner_id IS NOT NULL'
      )
    else
      @partner_sites = PartnerSite.all(
        :conditions => [ 'partner_id = ?', current_user.partner.id ]
      )
    end
  end
  
  def new
    @partner_site = PartnerSite.new
    if current_user.has_role? 'admin'
      @partner_site.partner_id = Partner.find(:first).id
    else
      @partner_site.partner_id = current_user.partner.id
    end
  end

  def update
    @partner_site = PartnerSite.find params[ :id ]
    @partner_site.update_attributes( params[ :partner_site ])
    flash[ :notice ] = "Partner Site Updated Successfully."
    redirect_to "/publishers/partner_sites" and return
  end

  def show
    @partner_site = PartnerSite.find params[ :id ]
  end

  def show_quizzes
    @partner_site = PartnerSite.find params[ :id ]
    @quizzes = Quiz.all(
      :conditions => [ "partner_sites.id = ?", params[:id] ],
      :joins => { :partner => :partner_sites }
    )
  end

  def save
    @partner_site = PartnerSite.find params[ :id ]
    @quiz = Quiz.find(params[:quiz])
    if params[:show] == "true"
      @partner_site.quizzes << @quiz
    else
      @partner_site.quizzes.delete(@quiz)
    end
    @partner_site.save!
    render :nothing => true
  end

end
