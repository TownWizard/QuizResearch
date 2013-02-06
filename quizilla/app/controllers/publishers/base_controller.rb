class Publishers::BaseController < ApplicationController

  #include RoleRequirementSystem
  #include EasyRoleRequirementSystem
  helper 'publishers/publishers'
  
  before_filter :require_user

  private

  def authorize_publisher_global_access
    if current_user && current_user.authorized_for_partner_site?( @partner_site )
      matching_roles = [
        'admin'
      ].detect do |role_needed|
        current_user.has_role? role_needed
      end

      if matching_roles != nil
        return true
      else
        flash[ :notice ] = "We recognized your credentials, but you are not authorized to view this page.  Please contact your administrator."
        redirect_to :controller => 'publishers/sessions', :action => 'new'
        return false
      end
    end
  end

  def authorize_publisher_basic_access
#    if current_user && current_user.authorized_for_partner_site?( @partner_site )
    if current_user 
      matching_roles = [
        'admin',
        'partner_admin',
        'partner_report_viewer',
        'partner_site_report_viewer'
      ].detect do |role_needed|
        current_user.has_role? role_needed
      end

      if matching_roles != nil
        return true
      else
        flash[:notice] = "We recognized your credentials, but you are not authorized to view this page.  Please contact your administrator."
        redirect_to :controller => 'publishers/sessions', :action => 'new'
        return false
      end
    else
      flash[:notice] = "We recognized your credentials, but you are not authorized to view this page.  Please contact your administrator."
      redirect_to :controller => 'publishers/sessions', :action => 'new'
      return false
    end
  end

  def authorize_site_admin_access
    if current_user && current_user.authorized_for_partner_site?( @partner_site )
      matching_roles = [
        'admin',
        'partner_admin'
      ].detect do |role_needed|
        current_user.has_role? role_needed
      end

      if matching_roles != nil
        return true
      else
        flash[:notice] = "We recognized your credentials, but you are not authorized to view this page.  Please contact your administrator."
        redirect_to :controller => 'publishers/sessions', :action => 'new'
        return false
      end
    end
  end

  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to :controller => 'publishers/sessions', :action => 'new'
      return false
    end
  end

  def publishers_redirect redirect_anchor
    #redirect_to "/publishers/quizzes/show/#{params[ :quiz_phase ][ :quiz_id ]}#{params[ :redirect_anchor ]}" and return
    redirect_to "/publishers/quizzes/#{params[ :id ]}##{redirect_anchor}"
  end
end
