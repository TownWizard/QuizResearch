class InvitationsController < ApplicationController
  before_filter :current_newsletter_site
  
  def new
    @invitation = Invitation.new
  end

  def create
    invitations_count = Invitation.send_multiple(params[:invitation], params[:invitation][:sender_id], @newsletter)
    flash[:notice] = "Thank you, #{invitations_count} invitations sent."
    redirect_to root_url
  end

end
