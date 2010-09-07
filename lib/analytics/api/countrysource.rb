class CountrySource 
  include StatGetters
  #
  #This is a complete clone of the websources class, but with the 
  #bounce rates and average times taken out of the report,
  #they're commented out, they can be returned if needed
  #
  
  attr_reader :all_results, :reporting_list, :previous_list, :baseline_list
  
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

    @list_countries = Array.new
    @list_visits = Array.new
    @list_bounces = Array.new
    @list_times = Array.new
    
    @reporting_list = ["You need to run my method :|"]
    @previous_list = ["You need to run my method :|"]
    @baseline_list = ["You need to run my method :|"]

  end
  
  def to_s
    "#{@all_results}, #{@arbitrary}, #{@reporting}, #{@previous}, #{@baseline}, #{@list_countries}, #{@list_visits}, #{@list_bounces}, #{@list_times}, #{@reporting_list}, #{@previous_list}, #{@baseline_list}, arbitrary? = #{self.arbitrary?}"    
  end

  def processed_reporting(limit = 10)
    processed_arbitrary($periods.start_date_reporting, $periods.end_date_reporting, limit)
  end
  
  def processed_arbitrary(start_date, end_date, limit = 10)
    #takes start_time end_time and an int for results limit
    #returns sources with percentage of total visits, bouncerate,
    #and average session times
             
    self.arbitrary(start_date, end_date, limit) #get numbers
    
    self.make_visits_percentages_of_total(start_date, end_date) #make numbers useful
    self.make_bounces_rates
    self.make_times_average_sessions
    
    i = @list_countries.length
    x = 0
    
    @average_sessions = Num.make_seconds(@average_sessions)
    
    rows = Array.new
    
    while i > 0
      a = Array.new
      a << "#{@list_countries[x]}"                           #countries
      a << "#{Num.to_p(@visits_as_percent[x])}"              #visits/total
      a << "#{Num.to_p(@rates[x])}"                          #bounce-rates
      a << "#{@average_sessions[x].strftime("%M:%S")}"       #average-sessions
      
      rows << a
      
      i = i - 1
      x = x + 1
    end
    
    header = ["Country", "Visits/total", "Bounce rate", "Avg session"]
    
    hash = { :title => "Geographic sources", :table_id => "country_sources", :header => header, :rows => rows}
    
    @all_results = OpenStruct.new(hash)
    @all_results 
  end
  
  def processed_reporting(limit = 10)
    @reporting_list = self.processed_arbitrary(@start_date_reporting, 
                                                               @end_date_reporting, 
                                                               limit)
    @reporting_list
  end
  
  def processed_previous(limit = 10)
    @previous_list = self.processed_arbitrary(@start_date_previous, 
                                                              @end_date_previous, 
                                                              limit)
    @previous_list
  end
  
  def processed_baseline(limit = 10)
    @baseline_list = self.processed_arbitrary(@start_date_baseline, 
                                                              @end_date_baseline, 
                                                              limit)
    @baseline_list
  end
  
  def arbitrary(start_date, end_date, limit = 10)
    #minor report, requires a start_date, end_date
    #takes int as limit on results
    #includes bounces and time on site
    report = Garb::Report.new($profile.garb,
                              :start_date => start_date,
                              :end_date => end_date,
                              :limit => limit)
                              
    if $profile.segment? 
      report.set_segment_id($profile.segment)
    end
                              
    report.metrics :visits# , :bounces, :timeOnSite
    report.dimensions :country
    report.sort :visits.desc
    
    @list_countries = Array.new #re initialized in case they were called previously...
    @list_visits = Array.new  #as this is structured in a way where that isn't unlikely...
    @list_bounces = Array.new #ie for three period reports....
    @list_times = Array.new
            
    report.results.each {|thing| @list_countries << thing.country}
    report.results.each {|thing| @list_visits << thing.visits}
    report.results.each {|thing| @list_bounces << thing.bounces}
    report.results.each {|thing| @list_times << thing.time_on_site}
    
  end
  
  def up_is_nothing?
    return true
  end
  
  def arbitrary? 
    return false
  end
   
end