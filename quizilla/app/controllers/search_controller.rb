class SearchController < ApplicationController

  @@HTTP = Net::HTTP.new( 'localhost', '8983' )

  # constructs a search from a given entry's boost_keywords.
  # expects an entry_type and entry_id parameters
  def auto_by_boosted_keywords

    rows = 10
    page = params[ :page ] ||= 1

    @entry = Class.const_get( params[ :entry_type ].camelcase ).find( params[ :entry_id ] )

    query = ""
    str = @entry.boost_keywords

    #debugger
    if str
      query = str.gsub( /,/, " " )
    else
      render :text => "<p><b>This entry has no boost keywords associated with it.  Please add some using the link above.</b></p>"
      return
    end

    @items = @entry.auto_search :highlight => true
    
#    # solr uses start / offset, and will paginate uses page.  we convert those
#    # paging params here.
#    # determine the start and offset based on page and number of total result docs.
#    if page.to_i == 1
#      start = 0
#    else
#      start = ( page.to_i - 1 ) * rows.to_i
#    end
#
#    path = "/solr/select?q=#{CGI.escape(query)}"
#    path += "&fq=%2Bmaxwell_document_type:item"
#    path += "&start=#{start}&rows=#{rows}"
#    path += "&qf=item_title^100+search_keywords^100+mlt_content^100"
#    path += "&ps=100&qs=100"
#    path += "&mm=1&qt=dismax&wt=ruby"
#    path += "&hl=true&hl.requireFieldMatch=true"
#
#    #path += "&echoParams=all"
#
#    # our response comes back as a modified JSON result set, already set up for
#    # east eval into a ruby data structure.
#    RAILS_DEFAULT_LOGGER.info "Path: #{path}"
#    @response, @data = @@HTTP.get( path )
#    @solr_result = eval( @data )
#
#    RAILS_DEFAULT_LOGGER.info "Response: #{@response}"
#    RAILS_DEFAULT_LOGGER.info "Response: #{@data}"
#
#    total_results = @solr_result[ 'response' ][ 'numFound' ]
#    if total_results.to_i > 0
#      @fake_result = WillPaginate::Collection.new( page, rows, total_results )
#      ids = Array.new
#      @solr_result[ 'response' ][ 'docs' ].each { |d| ids << d[ 'item_id' ] }
#
#      # remember that we are just doing an id search, so we need to be explicit about
#      # the sort order.
#      @items = Item.find( :all, :conditions => "items.id IN ( #{ids.join( ',' )} )", :include => [ :source ] )
#    end

  end

  def mlt

    rows = 10
    page = params[ :page ] ||= 1

#    @entry = Class.const_get( params[ :entry_type ].camelcase ).find( params[ :entry_id ] )
#
#    str = @entry.boost_keywords
#    query = ""
#
#    if str
#      query = str.gsub( /,/, " " )
#    end

    # solr uses start / offset, and will paginate uses page.  we convert those
    # paging params here.
    # determine the start and offset based on page and number of total result docs.
    if page.to_i == 1
      start = 0
    else
      start = ( page.to_i - 1 ) * rows.to_i
    end


    #set up basic connection
    @url = URI.parse( 'http://localhost:8983/solr/mlt' )
    @http = Net::HTTP.new( @url.host, @url.port )
    @path = @url.path

    @query =  "?q=#{params[:q]}"
    @query += "&mlt.fl=mlt_content&mlt.boost=true&mlt.count=10&mlt.interestingTerms=details"
    @query += "&mlt.maxqt=10&mlt.minwl=6&mlt.maxwl=20"
    #query += "&fl=item_title,item_it,item_search_keywords,score"
    @query += "&wt=ruby&fq=maxwell_document_type:item"
    @query += "&hl=true&hl.requireFieldMatch=true"
    #@query += "&qt=dismax&wt=ruby"

    @response, @data = @http.get( "#{@path}/#{@query}" )

    RAILS_DEFAULT_LOGGER.info "-----"
    RAILS_DEFAULT_LOGGER.info "#{@path}/#{@query}"
    RAILS_DEFAULT_LOGGER.info "-----"
    
    @solr_result = eval( @data )

    total_results = @solr_result[ 'response' ][ 'numFound' ]
    if total_results.to_i > 0
      @fake_result = WillPaginate::Collection.new( page, rows, total_results )
      ids = Array.new
      @solr_result[ 'response' ][ 'docs' ].each { |d| ids << d[ 'item_id' ] }

      # remember that we are just doing an id search, so we need to be explicit about
      # the sort order.
      @items = Item.find( :all, :conditions => "items.id IN ( #{ids.join( ',' )} )", :include => [ :source ] )
#      @items.each do |item|
#        item[ :highlight_results ] = @solr_result[ 'highlighting' ][ item.solr_document_id ]
#      end
    end
    #wants.js
  end

  def search

    #http = Net::HTTP.new( 'localhost', '8080' )
    rows = 25
    page = params[ :page ] ||= 1
    str = CGI.escape( params[ :search_string ] )

    if str == ''
    	str = 'maxwell'
    end

    #path = "/solr/select?q=#{str}&rows=0&wt=ruby"
    #@response, @data = http.get( path )
    #@result = eval( @data )

    # solr uses start / offset, and will paginate uses page.  we convert those
    # paging params here.
    # determine the start and offset based on page and number of total result docs.
    if page.to_i == 1
      start = 0
    else
      start = ( page.to_i - 1 ) * rows.to_i
    end

    path = "/solr/select?q=%22#{str}%22&start=#{start}&rows=#{rows}&qt=dismax&wt=ruby"

    # our response comes back as a modified JSON result set, already set up for
    # east eval into a ruby data structure.
    @response, @data = @@HTTP.get( path )
    @search_result = eval( @data )
    total_results = @result[ 'response' ][ 'numFound' ]
    if total_results.to_i > 0
      @solr_result = WillPaginate::Collection.new( page, rows, total_results )
      ids = Array.new
      @result[ 'response' ][ 'docs' ].each { |d| ids << d[ 'item_id' ] }

      # remember that we are just doing an id search, so we need to be explicit about
      # the sort order.
      @items = Item.find( :all, :conditions => "items.id IN ( #{ids.join( ',' )} )", :include => [ :source ] )
    end
  end
  
end
