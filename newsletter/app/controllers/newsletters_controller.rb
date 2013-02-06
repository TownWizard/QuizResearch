class NewslettersController < ApplicationController
  before_filter :current_newsletter_site
  before_filter :allow_admin_only?

  def show
    if params[:invite]
      @invitation = Invitation.find_by_token(params[:invite])
      redirect_to newsletter_url if @invitation.nil?
    end
  end
end
