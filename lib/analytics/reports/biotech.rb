class Biotech < Report
  attr_accessor :name
  
  def initialize(name = "Biotech deatiled report")
    @name = name
    @now = DateTime.now
    
    @dir = "#{DateTime.now.strftime("%d%m%M%S")}"
    @file = File.new($path + "/#{@name}-#{@now.strftime("%d%m")}.txt",  "w+")
  end

  def session_startup
    $profile = Profile.new
    $profile.string = "Biotech"
    $profile.garb = Garb::Profile.first('6076893')
  end
  
  def main
    $format.x.report{self.page_1}
    $format.finish
  end
  
  def page_1
    
    visits = Visits.new
    uniques = Uniques.new
    bounces = BounceRate.new
    times = Times.new
    pages_visits = PageViews.new
    traffic_sources = WebSources.new
    countries = CountrySource.new
    new_returning = NewVisits.new
    
    
    $format.x.page( "id" => "1"){
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
  
end