module Publishers::PublishersHelper

  def publishers_entry_tokens_form_link( entry_type, entry_id, quiz_id, update = 'solr-results' )
    "<a href=\"/publishers/tokens/for_entry?entry_type=#{entry_type}&entry_id=#{entry_id}&quiz_id=#{quiz_id}\"  class=\"lbOn\">Keywords</a>"
#    link_to_remote(
#      "Edit Boost Keywords",
#      :url => "/publishers/tokens/for_entry?entry_type=#{entry_type}&entry_id=#{entry_id}&quiz_id=#{quiz_id}",
#      :update => update,
#      :method => 'GET',
#      :html => { :class => 'lbOn' } )
  end

  def publishers_auto_search_link( entry_type, entry_id, quiz_id, update = 'solr-results' ) # old method signature
  #def publishers_auto_search_link( entry_type, entry_id, quiz_id )
    link_to_remote(
      "Search by Boosted Keywords",
      :url => url_for( :controller => '/search', :action => :auto_by_boosted_keywords, :entry_type => entry_type, :entry_id => entry_id ),
        #"/search/auto/entry_type=#{entry_type}&entry_id=#{entry_id}&quiz_id=#{quiz_id}",
      :update => update )
  end

  def redirect_anchor_tag anchor_value = 'top'
    "<input type='hidden' name='redirect_anchor' value='#{anchor_value}' />"
  end

end
