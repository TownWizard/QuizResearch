class Publishers::UsersController < Publishers::BaseController

  layout 'publishers'
  
  before_filter :authorize_site_admin_access

  def create
    params[ :user ][ :login ] = params[ :user][ :email ]
    params[ :user ][ :partner_id ] = params[:partner_site_user][:partner_id]
    user = User.create! params[ :user ]
    if  params[ :user_roles ] == 'partner_site_report_viewer'
      user.partner_site=PartnerSite.find_by_id params[:partner_site_user][:partner_site_id]
      user.save
    end

    params[ :user_roles ].each do |r|
      user.roles << Role.find_by_name( r )
    end

    # this is the admin partner.  it is only set for admin users.
    if current_user.has_role? 'admin'
      user.partner = Partner.find_by_id params[ :partner_site_user ][ :partner_id ]
      user.save
    else
      user.partner = current_user.partner
    end
    
    flash[ :notice ] = "User Created Successfully."
    redirect_to "/publishers/users" and return
  end

  def edit
    @partner_site_user = User.find params[ :id ]
    @partner_sites = PartnerSite.all :conditions => [ 'partner_id = ?', @partner_site_user.partner_id ]
    @user_role = @partner_site_user.roles.first.name
  end

  def update
    @partner_site_user = User.find params[ :id ]
    @partner_site_user.update_attributes( params[ :user ])
    if  params[ :user_roles ] == 'partner_site_report_viewer'
      @partner_site_user.partner_site=PartnerSite.find_by_id params[ :partner_site_user ][ :partner_site_id ]
      @partner_site_user.save
    end

    @partner_site_user.roles.delete_all
    @partner_site_user.save
    params[ :user_roles ].each do |r|
      @partner_site_user.roles << Role.find_by_name( r )
    end

    if current_user.has_role? 'admin'
      @partner_site_user.partner = Partner.find_by_id params[ :partner_site_user ][ :partner_id ]
      @partner_site_user.save
    else
      @partner_site_user.partner = current_user.partner
    end

    flash[ :notice ] = "User Updated Successfully."
    redirect_to "/publishers/users" and return
  end


  def index
    if current_user.has_role? 'admin'
      @partner_site_users = User.all(
        :conditions => 'partner_id IS NOT NULL'
      )
    else
      @partner_site_users = User.all(
        :conditions => [ 'partner_id = ?', current_user.partner.id ]
      )
    end
  end
  
  def new
    @partner_site_user = User.new
    if current_user.has_role? 'admin'
      @partner_site_user.partner_id = Partner.find(:first).id
      @partner_sites = PartnerSite.all :conditions => [ 'partner_id = ?', @partner_site_user.partner_id ]
    else
      @partner_site_user.partner_id = current_user.partner.id
      @partner_sites = current_user.authorized_partner_sites
    end
  end

  def destroy

  end

  def select_current_partner_site
    session[:partner_site_id] = params[:current_partner_site_id]
    respond_to do |wants|
      wants.html { redirect_to "/#{params[:controller_url]}" and return }
    end
  end

  def select_partner_site_list
    @partner_sites = PartnerSite.all :conditions => [ 'partner_id = ?', params[:current_partner_id] ]
    @curr_sel_site=@partner_sites.size>0?@partner_sites[0].id : 0
    render :partial => 'partner_site_select', :layout => false
  end
end
