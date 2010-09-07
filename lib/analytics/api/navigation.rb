class Navigation 
  attr_reader :all_results, :results_arbitrary, :in_results, :out_results
  
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
    
    @in_results = ["You need to run my methods :|"]
    @out_results = ["You need to run my methods :|"]
    
    @results_arbitrary = ["You need to run my methods :|"]
    
    @filter = "/" #this defaults to "/"
    @limit = 7 #defaults to 7

  end
  
  def to_s
    "#{@all_results}, #{@filter}, limit #{@limit}  #{@in_results}, #{@out_results},  arbitrary? = #{self.arbitrary?}"    
  end
  
  def all_reporting(filter = @filter, 
                    limit = @limit)
     
     self.arbitrary_in(filter, limit, @start_date_reporting, @end_date_reporting)
     self.arbitrary_out(filter, limit, @start_date_reporting, @end_date_reporting)
     
     @all_results = Array.new
     
     @all_results << "\nPrevious pages for #{filter}\n"
     @in_results.each {|thing| @all_results << thing}
     
     @all_results << "\nNext pages for #{filter}\n"
     @out_results.each {|thing| @all_results << thing}
     
     @all_results
  end
  
  def arbitrary_in(filter = @filter, 
                    limit = @limit,
                    start_date = @start_date_reporting, 
                    end_date = @end_date_reporting)
    
    report = Garb::Report.new($profile.garb,
                              :start_date => start_date,
                              :end_date => end_date,
                              :limit => limit)
    
    if $profile.segment?
      report.set_segment_id($profile.segment)
    end
    
    report.metrics :pageviews
    report.dimensions :previousPagePath, :pagePath

    report.filters do
      eql(:pagePath, filter)
    end

    report.filters do
      eql(:pagePath, filter.downcase) 
      #for domains that have capitalized and non capitalized instances in their history
    end

    report.filters do
      eql(:pagePath, filter.gsub("-", "_"))  
      #for changes in how spaces are handled... this was added for the sake of the hubs...
    end
    
    report.sort :pageviews.desc
    

    @in_results = Array.new
    
    report.results.each do |thing|
      @in_results << "#{thing.previous_page_path} (#{thing.pageviews})"
    end
    
    @in_results
  end
  
  def arbitrary_out(filter = @filter, 
                    limit = @limit,
                    start_date = @start_date_reporting, 
                    end_date = @end_date_reporting)
    
    report = Garb::Report.new($profile.garb,
                              :start_date => start_date,
                              :end_date => end_date,
                              :limit => limit)
    
    if $profile.segment?
      report.set_segment_id($profile.segment)
    end
    
    report.metrics :pageviews
    report.dimensions :nextPagePath, :previousPagePath

    report.filters do
      eql(:previousPagePath, filter)
    end

    report.filters do
      eql(:previousPagePath, filter.downcase) 
      #for domains that have capitalized and non capitalized instances in their history
    end

    report.filters do
      eql(:previousPagePath, filter.gsub("-", "_"))  
      #for changes in how spaces are handled... this was added for the sake of the hubs...
    end

    report.sort :pageviews.desc
    

    @out_results = Array.new
    
    report.results.each do |thing|
      @out_results << "#{thing.next_page_path} (#{thing.pageviews})"
    end
    
    @out_results
  end
  
  def up_is_nothing?
    false
  end
  
  def up_is_good?
    false
  end
  
  def arbitrary?
    return false
  end
  
  
end