class Biotech < Report
  attr_accessor :name
  
  def initialize(name = "Biotech deatiled report")
    @name = name
    @now = DateTime.now
    
    @dir = "#{DateTime.now.strftime("%d%m%M%S")}"
    @path = File.expand_path(File.dirname(__FILE__) + "/../../../output/#{@dir}")
    FileUtils.mkdir_p @path
    @file = File.new(@path + "/#{@name.gsub(" ", "-").downcase}-#{@now.strftime("%d%m")}.xml",  "w+")
    $path = @path #export path variable for formatting classes that need it
  end

  def session_startup
    $profile = Profile.new
    $profile.string = "Biotech"
    $profile.garb = Garb::Profile.first('6076893')
  end
  
  def main
    $format.x.tag!(@name){self.front_page
      
                          self.country("New Zealand", "1223813495")
                          self.country("Australia", "930734061")
                          self.country("United States", "759299489")
                     
                          self.country_no_bounce("New Zealand > 2 min", "1132433923")     
                          self.visitor_type("Search", "-6")      
                          self.visitor_type("New", "-2")
      }
    
    
    
    
    $format.finish
  end
  
  def front_page(title = "Front page")
    
    visits = Visits.new
    uniques = Uniques.new
    bounces = BounceRate.new
    times = Times.new
    pages_visits = PageViews.new
    traffic_sources = WebSources.new
    countries = CountrySource.new
    new_returning = NewVisits.new
    
    
    $format.x.tag!(title){
      $format.x.comment!("Header!")
      $format.title("Sciencelearn.org.nz", "Traffic summary")
      $format.date_section



        $format.x.comment!("Main body!")


        $format.main_graph(visits.main_graph)

        $format.table(traffic_sources.processed_reporting_bounce_and_time(7))

        $format.table(countries.processed_reporting(7))

        $format.bar_series(visits.hours_graph)

        $format.x.comment!("Right hand section!")

        $format.block_full(visits.three_with_changes) #blocks
        $format.block_full(uniques.three_monthly_averages)
        $format.block_full(bounces.three_with_changes)
        $format.block_full(times.three_with_changes_as_averages)
        $format.block_full(pages_visits.three_with_changes_per_visit)


        $format.comparison(new_returning.reporting_only)      #bar
    }
  end
  
  def country(page = "-", segment = nil, segment_string = nil, modifier = nil)
    
    $profile.segment = segment
    $profile.segment_string = segment_string
    
    visits = Visits.new
    uniques = Uniques.new
    bounces = BounceRate.new
    times = Times.new
    pages_visits = PageViews.new
    new_returning = NewVisits.new
    traffic_sources = WebSources.new
    engagement_pages = Content.new
    
    $format.x.tag!(page){
      $format.x.comment!("Header!")
      $format.title(page, "By Country")
      $format.date_section
      
        $format.x.comment!("Main body!")


        $format.main_graph(visits.main_graph)
        $format.bar_series(visits.hours_graph)
        
        $format.table(traffic_sources.processed_reporting_bounce_and_time(5))
        $format.table(engagement_pages.ordered_by_pageviews($periods.start_date_reporting, $periods.end_date_reporting, 8))
        $format.table(engagement_pages.ordered_by_time($periods.start_date_reporting, $periods.end_date_reporting, 8))
        
        $format.x.comment!("Right hand section!")

        $format.block_full(visits.three_with_changes) #blocks
        $format.block_full(uniques.three_monthly_averages)
        if modifier != "b"
          $format.block_full(bounces.three_with_changes)
        end        
        $format.block_full(times.three_with_changes_as_averages)
        $format.block_full(pages_visits.three_with_changes_per_visit)

        $format.comparison(new_returning.reporting_only)      #bar
         
    }
    
    $profile.segment = nil #reset
    $profile.segment_string = nil #reset
    
  end
  
  def country_no_bounce(page = "-", segment = nil, segment_string = nil)
    self.country(page, segment, segment_string, "b")
  end
  
  def visitor_type(page = "-", segment = nil, segment_string = nil)   #make me work with modifier
    
    $profile.segment = segment
    $profile.segment_string = segment_string
    
    visits = Visits.new
    uniques = Uniques.new
    bounces = BounceRate.new
    times = Times.new
    pages_visits = PageViews.new
    new_returning = NewVisits.new
    traffic_sources = WebSources.new
    engagement_pages = Content.new
    
    $format.x.tag!(page){
      $format.x.comment!("Header!")
      $format.title(page, "Visitor type")
      $format.date_section
      
        $format.x.comment!("Main body!")


        $format.main_graph(visits.main_graph)
        
        $format.table(traffic_sources.processed_reporting_bounce_and_time(5))
        $format.table(engagement_pages.ordered_by_pageviews($periods.start_date_reporting, $periods.end_date_reporting, 8))
        $format.table(engagement_pages.ordered_by_time($periods.start_date_reporting, $periods.end_date_reporting, 8))
        
        $format.x.comment!("Right hand section!")

        $format.block_full(visits.three_with_changes) #blocks
        $format.block_full(bounces.three_with_changes)

            #add depth #add loyalty
    }
    
    $profile.segment = nil #reset
    $profile.segment_string = nil #reset
    
  end
  

  
  
end

























