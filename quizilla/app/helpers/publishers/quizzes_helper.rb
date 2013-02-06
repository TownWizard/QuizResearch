module Publishers::QuizzesHelper

  def publishers_add_link( name, url_string, element_to_update )
    link_to_remote( name, :url => url_string, :method => 'GET', :update => element_to_update )
  end

  # outputs an href remote link with parameters appropriate for returning
  # MoreLikeThis results for a given query.  The query must be in Lucene Query Syntax.
  # Google it if you need to.
  #
  # * record: an instance of a gmc_solr enabled class.
  # * update_me: the DOM id of the element to update with the results, as a string.
  # * record_label: an extra label for the benefit of the user.  You should supply it.
  
  def publishers_gmc_solr_remote_mlt_link( record, update_me, record_label = 'record' )
    link_to_remote \
      "Show me auto-generated stories for this #{record_label}",
      :url => {
        :controller => '/search',
        :action => 'mlt',
        :q => "#{record.solr_unique_doc_query}",
        :doc_type => record.class.class_name.downcase.underscore
      },
      :update => update_me
  end
  
end
