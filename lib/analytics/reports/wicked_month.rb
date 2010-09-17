class WickedMonth
  attr_accessor :name
  
  def initialize(name = "Wicked month details")
    @name = name
    @now = DateTime.now
    
    @dir = "wicked_monthlies"
    @path = File.expand_path(File.dirname(__FILE__) + "/../../../output/#{@dir}")
    FileUtils.mkdir_p @path
    @file = File.new(@path + "/#{@name.gsub(" ", "-").downcase}-#{@now.strftime("%d%m")}.txt",  "w+")
    $path = @path #export path variable for formatting classes that need it
  end

  def session_startup
    $profile = Profile.new
    $profile.string = "WickED"
    $profile.garb = Garb::Profile.first('14608700')
  end
  
  def all
    $format.header("WickED", "Quick monthly summary")
    
    uniques = Uniques.new
    visits = Visits.new
    pageviews = PageViews.new
    bounce = BounceRate.new
    time = Times.new
    
    $format.single("Uniques", uniques.reporting.to_s)
    $format.single("Visits", visits.reporting.to_s)
    $format.single("Pageviews", pageviews.reporting.to_s)
    $format.single("Bouncerate", "#{bounce.reporting.to_s}" + "%")
    $format.single("Average time", time.reporting_average.to_s)
    
    $format.table(engagement_pages.ordered_by_pageviews($periods.start_date_reporting, $periods.end_date_reporting, 12))
    $format.table(engagement_pages.ordered_by_time($periods.start_date_reporting, $periods.end_date_reporting, 12))    
  end
  
end