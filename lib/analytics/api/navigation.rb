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
     
     if @in_results.rows.length != @out_results.rows.length
       raise "Error creating output for Navigation.all_reporting. @in_results and @out_results have different length arrays."
     end
     
     if @in_results.rows.length != limit
       raise "Error creating output for Navigation.all_reporting. @in_results is not the length of the specified return limit."
     end
     
     rows = Array.new
     
     i = 0
     while i < limit
       a = Array.new
       a << @in_results.rows[i].fetch(0)
       a << @in_results.rows[i].fetch(1)
       a << @out_results.rows[i].fetch(0)
       a << @out_results.rows[i].fetch(1)
       
       rows << a
       i = i + 1
    end
     
    header = ["#{@in_results.header[0]}", "#{@in_results.header[1]}", "#{@out_results.header[0]}", "#{@out_results.header[1]}"]
     
    hash = { :title => "Navigation for #{filter}", :table_id => "navigation", :header => header, :rows => rows}
     
    @all_results = OpenStruct.new(hash)
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
    
    
    rows = Array.new
    
    report.results.each do |thing|
      a = Array.new
      a << "#{thing.previous_page_path}"
      a << "#{thing.pageviews}"
      
      rows << a
    end
    
    header = ["Previous pages for #{filter}", "Pageviews"]

    hash = { :title => nil, :table_id => "previous_pages", :header => header, :rows => rows}
    
    @in_results = OpenStruct.new(hash)
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
    rows = Array.new
    
    report.results.each do |thing|
      a = Array.new
      a << "#{thing.next_page_path}"
      a << "#{thing.pageviews}"
      rows << a
    end
    
    header = ["Next pages for #{filter}", "Pageviews"]

    hash = { :title => nil, :table_id => "next_pages", :header => header, :rows => rows}
    
    @out_results = OpenStruct.new(hash)
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