module PartnerSystem
  def load_partner_site
    if params[ :ps ]
      @partner_site = ::PartnerSite.find( 
        :first,
        :conditions => { :key => params[:ps], :deleted_at => nil } ) || ::PartnerSite.first
    else
      @partner_site = ::PartnerSite.find( 
        :first,
        :conditions => { :domain => request.domain(1), :host => request.subdomains(1), :deleted_at => nil } ) || ::PartnerSite.first
    end
    
    # also set to session
    unless session[ :partner_site_id ]
      session[ :partner_site_id ] = @partner_site.id
    end
  end

  def load_partner_site_and_taxonomies
    load_partner_site
    @taxonomies = @partner_site.taxonomies.for_display
  end
end
