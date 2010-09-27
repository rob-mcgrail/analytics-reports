class Keywords
  attr_reader :all_results
  include StatGetters
  
  
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
  
    report.metrics :visits, :bounces, :timeOnSite
    report.dimensions :keyword
  
    report.sort :visits.desc
  
    @list_keywords = Array.new #re initialized in case they were called previously...
    @list_visits = Array.new  #as this is structured in a way where that isn't unlikely...
    @list_bounces = Array.new #ie for three period reports....
    @list_times = Array.new
            
    report.results.each {|thing| @list_keywords << thing.keyword}
    report.results.each {|thing| @list_visits << thing.visits}
    report.results.each {|thing| @list_bounces << thing.bounces}
    report.results.each {|thing| @list_times << thing.time_on_site}
    
    self.make_bounces_rates
    self.make_times_average_sessions
    
    i = limit
    x = 0
    
    @average_sessions = Num.make_seconds(@average_sessions)
    
    rows = Array.new
    
    while i > 0
      a = Array.new
      a << "#{@list_keywords[x]}"                            #countries
      a << "#{@list_visits[x]}"                              #visits
      a << "#{Num.to_p(@rates[x])}"                          #bounce-rates
      a << "#{@average_sessions[x].strftime("%M:%S")}"       #average-sessions
      
      rows << a
      
      i = i - 1
      x = x + 1
    end
  
    header = ["Keyword", "Visits", "Bounces", "Avg Session"]

    hash = { :title => "Search keywords", :table_id => "search_keywords", :header => header, :rows => rows}
  
    @all_results = OpenStruct.new(hash)
    @all_results
  end
  
end