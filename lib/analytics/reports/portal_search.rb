class PortalSearch < Report
  
  def initialize(name = "Portal search terms")
    @name = name
    @now = DateTime.now
    
    @dir = "portal_searches"
    @path = File.expand_path(File.dirname(__FILE__) + "/../../../output/#{@dir}")
    FileUtils.mkdir_p @path
    @file = File.new(@path + "/#{@name.gsub(" ", "-").downcase}-#{@now.strftime("%d%m")}.csv",  "w+")
    $path = @path #export path variable for formatting classes that need it
  end
  
  def session_startup
    $profile = Profile.new
    $profile.string = "Portal"
    $profile.garb = Garb::Profile.first('35630502')
  end
  
  def all
    self.header
    self.queries
    $format.finish
    
  end
  
  def queries
    searches = Searches.new
    
    searches.reporting.each do |result|
      $format.values ["#{result.page_path}", "#{result.pageviews}"]
    end
    
  end
  
  def header
    $format.header ["Query", "Times"]
  end
  
end