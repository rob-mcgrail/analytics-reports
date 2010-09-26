class Keywords
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

  def reporting( start_date = @start_date_reporting, 
                    end_date = @end_date_reporting)
  
    report = Garb::Report.new($profile.garb,
                              :start_date => start_date,
                              :end_date => end_date,
                              :limit => limit)
  
    if $profile.segment?
      report.set_segment_id($profile.segment)
    end
  
    report.metrics :visits
    report.dimensions :keywords
  
    report.sort :visits.desc
  
  
    rows = Array.new
  
    report.results.each do |thing|
      a = Array.new
      a << "#{thing.keywords}"
      a << "#{thing.visits}"
    
      rows << a
    end
  
    header = ["Keyword", "Visits"]

    hash = { :title => "Search keywords", :table_id => "search_keywords", :header => header, :rows => rows}
  
    @all_results = OpenStruct.new(hash)
    @all_results
  end
  
end