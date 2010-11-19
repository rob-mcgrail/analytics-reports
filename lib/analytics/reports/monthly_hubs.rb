class HubsMonth < Report
  attr_accessor :name
  
  def initialize(name = "Biotech monthly details")
    @name = name
    @now = DateTime.now
    
    @dir = "hubs_monthlies"
    @path = File.expand_path(File.dirname(__FILE__) + "/../../../output/#{@dir}")
    FileUtils.mkdir_p @path
    @file = File.new(@path + "/#{@name.gsub(" ", "-").downcase}-#{$periods.start_date_reporting.strftime("%d%m")}-#{$periods.end_date_reporting.strftime("%d%m")}.txt",  "w+")
    $path = @path #export path variable for formatting classes that need it
  end

  def session_startup(hub)
    $profile = Profile.new
    $profile.string = "Biotech"
    $profile.garb = Garb::Profile.first(hub)
  end
  
  def main
    
    #page 1
    
    visits = Visits.new
    uniques = Uniques.new
    bounces = BounceRate.new
    times = Times.new
    pages_visits = PageViews.new
    traffic_sources = WebSources.new
    countries = CountrySource.new
    new_returning = NewVisits.new
    
    depth = Depth.new
    length = Length.new
    
    $format.collector << "\n\nPage 1\n\n"
    
    $format.header(@name, "Quick monthly summary")
    
    $format.main_graph(visits.main_graph)
    
    $format.block_full(visits.three_with_changes) #blocks
    $format.block_full(uniques.three_monthly_averages)
    $format.block_full(bounces.three_with_changes)
    $format.block_full(times.three_with_changes_as_averages)
    $format.block_full(pages_visits.three_with_changes_per_visit)
    
    $format.comparison(new_returning.reporting_only)
    
    $format.table(traffic_sources.processed_reporting_bounce_and_time(7))
    
    $format.table(countries.processed_reporting(7))
    
    $format.bar_series(visits.hours_graph)
    
    $format.labelled_series(depth.basic_five)
    
    $format.labelled_series(length.basic_five)
    
    
    #page 2
    
    
    $format.collector << "\n\nPage 2 -- New Zealand\n\n"
    
    $profile.segment = "1223813495"
    
    visits = Visits.new
    uniques = Uniques.new
    bounces = BounceRate.new
    times = Times.new
    pages_visits = PageViews.new
    traffic_sources = WebSources.new
    countries = CountrySource.new
    new_returning = NewVisits.new
    browsers = Browser.new
    loyalty = Loyalty.new
    
    depth = Depth.new
    length = Length.new
    
    $format.main_graph(visits.main_graph)
    
    $format.block_full(visits.three_with_changes) #blocks
    $format.block_full(uniques.three_monthly_averages)
    $format.block_full(bounces.three_with_changes)
    $format.block_full(times.three_with_changes_as_averages)
    $format.block_full(pages_visits.three_with_changes_per_visit)
    
    $format.comparison(new_returning.reporting_only)
    
    $format.table(traffic_sources.processed_reporting_bounce_and_time(7))
    
    $format.table(browsers.reporting(20))
    
    $format.bar_series(visits.hours_graph)
    
    $format.labelled_series(loyalty.basic_five)
    
    $format.labelled_series(depth.basic_five)
    
    $format.labelled_series(length.basic_five)
    
    
    #page 3
    
    
    $profile.segment = nil
    
    $format.collector << "\n\nPage 3 -- Content\n\n"
    
    content = Content.new
    navigation = Navigation.new
    
    $format.table(content.ordered_by_pageviews($periods.start_date_reporting, $periods.end_date_reporting, 25))
    
    content.calculate_limit($periods.start_date_reporting, $periods.end_date_reporting) #filter outliers from engagement by time stat
    
    $format.table(content.ordered_by_time($periods.start_date_reporting, $periods.end_date_reporting, 25))
    
    $format.table(navigation.all_reporting("/", 25))
    
    
    #page 4
    
    
    $format.collector << "\n\n   -- New Zealand >2mins\n\n"
    
    $profile.segment = "1132433923"
    
    
    content = Content.new
    navigation = Navigation.new
    
    $format.table(content.ordered_by_pageviews($periods.start_date_reporting, $periods.end_date_reporting, 25))
    
    content.calculate_limit($periods.start_date_reporting, $periods.end_date_reporting) #filter outliers from engagement by time stat
    
    $format.table(content.ordered_by_time($periods.start_date_reporting, $periods.end_date_reporting, 25))
    
    $format.table(navigation.all_reporting("/", 25))
    
    
    #page 5
    
    
    $profile.segment = nil

    $format.collector << "\n\nPage 5 -- Search\n\n"
    
      
    keywords = Keywords.new
    
    $format.table(keywords.reporting(20))
    
    $profile.segment = "1223813495"
    
    $format.collector << "\n\n   -- New Zealand\n\n"
    
    keywords = Keywords.new
    
    $format.table(keywords.reporting(20))
    
    $profile.segment = nil
    
    $profile.segment = "-6"
    
    search_visits = Visits.new
    
    $format.main_graph(search_visits.main_graph)
    
    $format.block_full(bounces.three_with_changes)
    $format.block_full(times.three_with_changes_as_averages)
    $format.block_full(pages_visits.three_with_changes_per_visit)
    
    content = Content.new
    
    $format.table(content.ordered_by_pageviews($periods.start_date_reporting, $periods.end_date_reporting, 25))
    
     
    $format.finish
  end
  
  
end