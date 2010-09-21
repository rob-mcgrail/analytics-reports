class WickedMonth < Report
  attr_accessor :name
  
  def initialize(name = "Wicked month details")
    @name = name
    @now = DateTime.now
    
    @dir = "wicked_monthlies"
    @path = File.expand_path(File.dirname(__FILE__) + "/../../../output/#{@dir}")
    FileUtils.mkdir_p @path
    @file = File.new(@path + "/#{@name.gsub(" ", "-").downcase}-#{$periods.start_date_reporting.strftime("%d%m")}-#{$periods.end_date_reporting.strftime("%d%m")}.txt",  "w+")
    $path = @path #export path variable for formatting classes that need it
  end

  def session_startup
    $profile = Profile.new
    $profile.string = "WickED"
    $profile.garb = Garb::Profile.first('14608700')
  end
  
  def main
    $format.header("WickED", "Quick monthly summary")
    
    uniques = Uniques.new
    visits = Visits.new
    pageviews = PageViews.new
    bounce = BounceRate.new
    time = Times.new
    engagement_pages = Content.new
    
    $format.single("Uniques", uniques.reporting.to_s)
    $format.single("Visits", visits.reporting.to_s)
    $format.single("Pageviews", pageviews.reporting.to_s)
    $format.single("Bouncerate", "#{bounce.reporting.to_s}" + "%")
    $format.single("Average time", Num.make_seconds(time.reporting_average).strftime("%M:%S"))
    
    $format.table(engagement_pages.ordered_by_pageviews($periods.start_date_reporting, $periods.end_date_reporting, 12))
    
    engagement_pages.calculate_limit($periods.start_date_reporting, $periods.end_date_reporting) #filter outliers from engagement by time stat
    
    $format.table(engagement_pages.ordered_by_time($periods.start_date_reporting, $periods.end_date_reporting, 12))    
    
    uniques = Uniques.new
    visits = Visits.new
    pageviews = PageViews.new
    bounce = BounceRate.new
    time = Times.new
    engagement_pages = Content.new
    
    $profile.segment = "1223813495"
    
    $format.x "New Zealand---------------"
    
    $format.single("Uniques", uniques.reporting.to_s)
    $format.single("Visits", visits.reporting.to_s)
    $format.single("Pageviews", pageviews.reporting.to_s)
    $format.single("Bouncerate", "#{bounce.reporting.to_s}" + "%")
    $format.single("Average time", Num.make_seconds(time.reporting_average).strftime("%M:%S"))
        
    $format.table(engagement_pages.ordered_by_pageviews($periods.start_date_reporting, $periods.end_date_reporting, 12))
    
    engagement_pages.calculate_limit($periods.start_date_reporting, $periods.end_date_reporting) #filter outliers from engagement by time stat
    
    $format.table(engagement_pages.ordered_by_time($periods.start_date_reporting, $periods.end_date_reporting, 12))
    
    
  
    $format.finish
  end
  
  
end