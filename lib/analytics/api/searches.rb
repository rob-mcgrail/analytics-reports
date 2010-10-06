class Searches
  
  def initialize
    @start_date_reporting = $periods.start_date_reporting
    @end_date_reporting = $periods.end_date_reporting
    @start_date_previous = $periods.start_date_previous
    @end_date_previous = $periods.end_date_previous
    @start_date_baseline = $periods.start_date_baseline
    @end_date_baseline = $periods.end_date_baseline
    @reporting_number_of_months = $periods.reporting_number_of_months
    @baseline_number_of_months = $periods.baseline_number_of_months

    @all_results = ["You need to run my methods :|"] #array of structs

    @arbitrary = [nil]
    @reporting = [nil]
    @previous = [nil]
    @baseline = [nil]

    @results_arbitrary = ["You need to run my methods :|"] #array of structs

    @content = Content.new

  end

  def to_s
    "#{@all_results}, #{@arbitrary}, #{@reporting}, #{@previous}, #{@baseline}, #{@results_arbitrary}"
  end

  def reporting(start_date = @start_date_reporting, end_date = @end_date_reporting)
    self.arbitrary(start_date, end_date)
    self.wash_to_query(@results_arbitrary)
    @results_arbitrary
  end

  
  def wash_to_query(results)
    
    results.each do |result|
          
      if s =~ /search\?SearchText=([a-z|\w|\s|_]+)/
        result.page_path = "#{$1}"
      end
      
    end
    
  end
  
  
  def wash(xml)
    xml.gsub!(/((\<|\<\/)([a-z|\w|\s|_])+)\//, "\\1-")  # washing forward slashes from tags

    xml.gsub!("&amp;", "&")     # washing escapes!

    xml.gsub!(/<\/?[^>]*>/) do |match|
      match.downcase!
      match.gsub(" ", "_")
    end
        
   xml
  end

  def arbitrary(start_date, end_date)
    
    @content
    
    report = Garb::Report.new($profile.garb,
                              :start_date => start_date,
                              :end_date => end_date)


    report.filters do
      contains(:pagePath, "search?SearchText=")
    end

    report.metrics :pageviews
    report.dimensions :pagePath
    report.sort :pageviews.desc


    @results_arbitrary = Array.new

    report.results.each do |thing|

      hash = { "page_path" => thing.page_path, "pageviews" => thing.pageviews.to_i}

      @results_arbitrary << OpenStruct.new(hash) #make in to array
    end
    @results_arbitrary 
  end
  
end