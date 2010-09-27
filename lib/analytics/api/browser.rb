class Browser
  attr_reader :all_results
  
  
  def initialize
    @start_date_reporting = $periods.start_date_reporting
    @end_date_reporting = $periods.end_date_reporting
    @start_date_previous = $periods.start_date_previous
    @end_date_previous = $periods.end_date_previous
    @start_date_baseline = $periods.start_date_baseline
    @end_date_baseline = $periods.end_date_baseline
    @reporting_number_of_months = $periods.reporting_number_of_months
    @baseline_number_of_months = $periods.baseline_number_of_months
    
    @all_results = ["You need to run my methods :|"]
    
    @arbitrary = nil
    @reporting = nil
    @previous = nil
    @baseline = nil

  end

  def reporting(limit = 20,
                start_date = @start_date_reporting, 
                end_date = @end_date_reporting)
  
    report = Garb::Report.new($profile.garb,
                              :start_date => start_date,
                              :end_date => end_date,
                              :limit => limit)
  
    if $profile.segment?
      report.set_segment_id($profile.segment)
    end
  
    report.metrics :visits
    report.dimensions :browser, :browserVersion
  
    report.sort :visits.desc
  
    @list_browsers = Array.new #re initialized in case they were called previously...
    @list_versions = Array.new #ie for three period reports....
    @list_visits = Array.new  #as this is structured in a way where that isn't unlikely...
            
    report.results.each {|thing| @list_browsers << thing.browser}
    report.results.each {|thing| @list_versions << thing.browser_version}
    report.results.each {|thing| @list_visits << thing.visits}

    
    i = limit
    x = 0
        
    rows = Array.new
    
    while i > 0
      a = Array.new
      a << "#{@list_browsers[x]}"                            #browser
      a << "#{@list_versions[x]}"                            #version
      a << "#{@list_visits[x]}"                              #visits
      
      rows << a
      
      i = i - 1
      x = x + 1
    end
  
    header = ["Browser", "Version", "Visits"]

    hash = { :title => "Browsers", :table_id => "browsers", :header => header, :rows => rows}
  
    @all_results = OpenStruct.new(hash)
    @all_results
  end
  
end