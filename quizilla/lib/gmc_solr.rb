
module ActiveRecord #:nodoc:
  module Acts #:nodoc:
    module GMCSolr 
      require 'htmlentities'
    # The including class MUST have a to_solr_index_doc method that
    # returns a real libxml object.  kthxbye.
    #
    # To use, just add the acts_as_gmc_solr method call.

      def self.included( base )
        base.extend( ClassMethods )
      end

      module ClassMethods
        def acts_as_gmc_solr
          class_eval <<-EOF
            include ActiveRecord::Acts::GMCSolr::InstanceMethods

            after_save :index_document

            words1 = YAML::load_file( 'util/harvester_stop_words.yml' )
            #words2 = YAML::load_file( 'util/harvester_stop_words2.yml' )
            words2 = []

            @@stop_words = words1.concat( words2 ).uniq
            @@HTTP = Net::HTTP.new( 'localhost', '8983' )

            def stop_words
              @@stop_words
            end

            def http
              @@HTTP
            end

          EOF
        end
      end

      # makes a base solr add doc.  may be overkill as its own method.
      module InstanceMethods
        def create_base_add_doc
          add_doc = XML::Document.new
          add_doc.root = XML::Node.new( 'add' )
          return add_doc
        end

         # takes element name and value and returns libxml object <field name='#{name}'>#{value}</field>
        def make_solr_index_field( name, value )
          field = XML::Node.new( 'field' )
          field[ 'name' ] = name
          field << value
          return field
        end

        # generates a libxml object representing the format of a solr add document
        # and POSTs the serialized xml to solr.  Note the hard coded url, please.

        def index_document( url_string = 'http://localhost:8983/solr/update' )
          index_doc = create_base_add_doc
          root = index_doc.root
          begin
            doc = to_solr_index_doc
            root << doc
            #set up basic connection
            @url = URI.parse( url_string )
            @http = Net::HTTP.new( @url.host, @url.port )
            
            response, body = @http.post( @url.path, index_doc.to_s, { 'Content-type'=>'text/xml; charset=utf-8' } )
            
            response, body = @http.post( @url.path, "<commit/>", { 'Content-type'=>'text/xml; charset=utf-8' } )

          rescue Exception => ex
            #puts "Something went wrong with item: #{item.id}: #{item.title}"
            puts ex.inspect
            puts ex.backtrace
          end
        end

        # filters a string against a big fat list of English stop words.  This
        # should NOT be used for fields intended for real, full text search.
        def mltify_text text
          
          coder = HTMLEntities.new
          text = coder.decode text
          text = sanitize( text, okTags = "" )
          text = coder.encode text
          words = text.downcase.gsub( /[^A-za-z0-9\s'\-#]/, " " ).split( /\s/ )
          
          final_words = []
          words.each do |w|
            unless stop_words.include? w
              final_words << w
            end
          end
          RAILS_DEFAULT_LOGGER.info final_words.join( ' ' ).squish
          final_words.join( ' ' ).squish
        end

        # generates a documentId value in the gmc sanctioned format.  These
        # uniquely identify records, and the unique bits are enforced by solr.

        def solr_document_id
          "#{self.class.class_name.underscore.downcase}-#{self.id}"
        end

        # generates a documentType value in the gmc sanctioned format.  these can
        # be used at query time to segment a search by document type.

        def solr_document_type
          "#{self.class.class_name.underscore.downcase}"
        end

        # puts the document_type and id together to form up a valid Lucene query
        # for a single document.

        def solr_unique_doc_query
          "maxwell_document_id:#{solr_document_id}"
        end

        def auto_search options = nil, rows = 5
          begin
          if options
            rows = options[ :rows ] ||= 5
            highlight = options[ :highlight ]
          end
          
          items = []
          
          # fall back top mlt_search if boost search doesn't cut it
          if boost_keywords
            
            items << boost_keyword_search( options )
            
            if items && items.size < rows
              items << mlt_search( options )
            end

          else 
            items << mlt_search( options )
          end
          items.flatten!
          items
          rescue
          end
        end

        def boost_keyword_search options = nil
          if boost_keywords != nil
            highlight = options && options[ :highlight ]

            str = boost_keywords.gsub( /,/, " " )
            path = "/solr/select?q=#{CGI.escape(str)}"
            path += "&fq=maxwell_document_type:item"
            path += "&start=0&rows=10"
            path += "&qf=item_title^100+search_keywords^100+mlt_content^100"
            path += "&ps=100&qs=100"
            path += "&mm=1&qt=dismax&wt=ruby"

            if highlight
              path += "&hl=true&hl.requireFieldMatch=true"
            end

            @response, @data = http.get( path )
            @solr_result = eval( @data )

            total_results = @solr_result[ 'response' ][ 'numFound' ]
            items = []
            if total_results.to_i > 0
              #@fake_result = WillPaginate::Collection.new( page, rows, total_results )
              ids = Array.new
              @solr_result[ 'response' ][ 'docs' ].each { |d| ids << d[ 'item_id' ] }

              # remember that we are just doing an id search, so we need to be explicit about
              # the sort order.
              items = Item.find( :all, :conditions => "items.id IN ( #{ids.join( ',' )} )", :include => [ :source ] )
            end

            # attach highlighting results
            if highlight
              items.each do |item|
                item[ :highlight_results ] = @solr_result[ 'highlighting' ][ item.solr_document_id ]
              end
            end
            #RAILS_DEFAULT_LOGGER.info "returning from auto: #{items.class}"
            items
          else
            []
          end
        end

        def mlt_search options = nil
          @path = "/solr/mlt"

          @query =  "?q=#{solr_unique_doc_query}"
          @query += "&mlt.fl=mlt_content&mlt.boost=true"
          @query += "&mlt.count=10&mlt.interestingTerms=details"
          @query += "&mlt.maxqt=10&mlt.minwl=6&mlt.maxwl=20"
          #query += "&fl=item_title,item_it,item_search_keywords,score"
          @query += "&wt=ruby&fq=maxwell_document_type:item"
          #@query += "&qt=dismax&wt=ruby"

          @response, @data = http.get( "#{@path}/#{@query}" )

#          RAILS_DEFAULT_LOGGER.info "-----"
#          RAILS_DEFAULT_LOGGER.info "#{@path}/#{@query}"
#          RAILS_DEFAULT_LOGGER.info "-----"

          @solr_result = eval( @data )

          total_results = @solr_result[ 'response' ][ 'numFound' ]
          items = []
          if total_results.to_i > 0
            #@fake_result = WillPaginate::Collection.new( page, rows, total_results )
            ids = Array.new
            @solr_result[ 'response' ][ 'docs' ].each { |d| ids << d[ 'item_id' ] }

            # remember that we are just doing an id search, so we need to be explicit about
            # the sort order.
            items = Item.find( :all, :conditions => "items.id IN ( #{ids.join( ',' )} )", :include => [ :source ] )
          end
          #RAILS_DEFAULT_LOGGER.info "returning from mlt: #{items.class}"
          items
        end

      end # end InstanceMethods
    end # end GMCSolr
  end
end