require 'feed-normalizer'

class WFeed 
  
  attr_reader :entries
  
  def initialize( io )
    feed = FeedNormalizer::FeedNormalizer.parse( io )
    @entries = Array.new
    feed.entries.each do |raw_entry| 
      this_entry = WEntry.new( raw_entry )
      @entries << this_entry
    end

  end

end

class WEntry
  attr_reader :id, :title, :content, :links, :date_published_by_source, :date_updated_by_source
    
  def initialize( entry )
    @id = entry.id
    @title = entry.title unless entry.title.nil?
    @content = entry.content unless entry.content.nil?
    @links = entry.urls
    
    #puts entry.date_published
    #puts entry.date_published.strftime( "%a, %d %b %H:%M:%S %z %Y" )
    #puts "====="
    #@date_published_by_source = DateTime.parse unless entry.date_published.nil?
    #@date_updated_by_source = DateTime.parse entry.date_updated_by_source unless not ( entry.respond_to?( "date_updated" ) )

    #use curent date if we can't find one on the entry
    if entry.date_published.nil?
      #puts "no_date_found."
      @date_published_by_source = DateTime.parse( Time.now.strftime( "%a, %d %b %H:%M:%S %z %Y" ) )
      #puts "From System Date: #{@date_published_by_source}"
    else 
      #puts "Raw Date String: #{entry.date_published}"
      @date_published_by_source = DateTime.parse( entry.date_published.strftime( "%a, %d %b %H:%M:%S %z %Y" ) ) unless entry.date_published.nil?
      #puts "After parse: #{@date_published_by_source}"
    end

    @date_updated_by_source = DateTime.parse( entry.date_updated_by_source.strftime( "%a, %d %b %H:%M:%S %z %Y" ) ) unless not ( entry.respond_to?( "date_updated" ) )
    
    @the_hash = Hash.new
    @the_hash[ "guid" ] = self.id
    @the_hash[ "title" ] = self.title
    @the_hash[ "content" ] = self.content
    @the_hash[ "link" ] = self.links[0]
    @the_hash[ "date_published_by_source" ] = self.date_published_by_source 
    @the_hash[ "date_updated_by_source" ] = self.date_updated_by_source
    return self

  end
  
  def get_all_text
    @title + ' ' + @content
  end
  
  def get_hash 
    return @the_hash
  end
  
  def inspect
    "Entry: \"#{@the_hash.inspect}\" ( #{self.object_id} )"
  end
  
  def as_hash
    return @the_hash
  end
end