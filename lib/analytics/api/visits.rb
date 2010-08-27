class Visits < Crunch
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
    
    @all_results = "You need to run my methods :|"
    
    @arbitrary = nil
    @reporting = nil
    @previous = nil
    @baseline = nil
    
    @arbitrary_list = nil
    @reporting_list = nil
    @previous_list = nil
    @baseline_list = nil
    
    @arbitrary_dates = nil
    @reporting_dates = nil
    @previous_dates = nil
    @baseline_dates = nil
    
    @arbitrary_hours = nil
    @reporting_hours = nil
    
    @baseline_average = nil
    
    @reporting_daily_average = nil
    @baseline_daily_average = nil
    
    @previous_change = nil
    @baseline_change = nil
  end
  
  def to_s
    "#{@all_results}, #{@arbitrary}, #{@reporting}, #{@previous}, #{@baseline}, #{@baseline_average}, #{@previous_change}%, #{@baseline_change}%, arbitrary? = #{self.arbitrary?}"
  end
  
  def three_with_changes
    #main report - prints a basic report for the 3 periods
    
    self.reporting
    self.previous
    self.baseline
    
    self.baseline_average
    self.baseline_change
    self.previous_change
    
    hash = { "title" => "Visits", "r" => @reporting.to_s, 
             "p_change" => self.to_p(@previous_change), "p_value" => @previous, "p_arrow" => self.arrow(@previous_change),
             "b_change" => self.to_p(@baseline_change), "b_value" => @baseline_average, "b_arrow" => self.arrow(@baseline_change)}
    
    @all_results = OpenStruct.new(hash)
    @all_results
  end
  
  # def by_hour_graph
  #   
  # end
  
  
  def main_graph
    #main report - gives out the numbers needed for a header graph by day for reporting period
    # plus averages for reporting and baseline
    
    self.reporting_by_day
    self.baseline_by_day
        
    @reporting_daily_average = @reporting_list.average
    @baseline_daily_average = @baseline_list.average
    
    x = @reporting_list.length #get length of the graph
    
    line1_array = Array.new
    line2_array = Array.new
    line3_array = Array.new
    
    @reporting_list.each {|thing| line1_array << thing}
    
    x.each do
      line2_array << @reporting_list.average        #stuff the two average lines with their value (they're straight lines...)
      line3_array << @baseline_list.average
    end
    
    keys_array = ["Visits", "Average", "Baseline"]  #add in the keys

    @reporting_list.each {|thing| @all_results << thing}
    
    hash = { "title" => "Visits", "keys" => keys_array,
             "line1" => line1_array, "line2" => line2_array, "line3" => line3_array}
    
    @all_results = OpenStruct.new(hash)
    @all_results
    end
  
  def hours_graph
    #main report - gives out the numbers needed for a by-hour graph
    
    self.reporting_by_hour
        
    @all_results = Array.new
    @all_results << "Reporting hourly visit values for graph:"

    @reporting_hours.each {|thing| @all_results << thing}
    
    @all_results
  end
    
  def baseline_average
    if @baseline_average.nil?
      @baseline_average = self.average_by_period
    end
    @baseline_average
  end
  
  def previous_change
    if @previous.nil?
      self.previous
    end
    
    if @reporting.nil?
      self.reporting
    end
    
    @previous_change = percentage_change(@previous, @reporting)
  end
  
  def baseline_change
    if @baseline_average.nil?
      self.baseline_average
    end
    
    if @reporting.nil?
      self.reporting
    end
    
    @baseline_change = percentage_change(@baseline_average, @reporting)
  end
  
  def arbitrary(start_date, end_date)
    #minor report, requires a start_date, end_date
    report = Garb::Report.new($profile.garb,
                              :start_date => start_date,
                              :end_date => end_date)
                              
    if $profile.segment? 
      report.set_segment_id($profile.segment)
    end
                              
    report.metrics :visits
          
    report.results.each {|thing| @arbitrary = thing.visits}
    @arbitrary.to_i
  end
  
  def reporting
    if @reporting.nil?
      @reporting = self.arbitrary(@start_date_reporting, @end_date_reporting)
    end
    @reporting.to_i
  end
  
  def previous
    if @previous.nil?
      @previous = self.arbitrary(@start_date_previous, @end_date_previous)
    end
    @previous.to_i
  end
  
  def baseline
    if @baseline.nil?
      @baseline = self.arbitrary(@start_date_baseline, @end_date_baseline)
    end
    @baseline.to_i
  end
  
  def arbitrary_by_hour(start_date, end_date)
    #minor report, requires a start_date, end_date
    report = Garb::Report.new($profile.garb,
                              :start_date => start_date,
                              :end_date => end_date)

    if $profile.segment? 
      report.set_segment_id($profile.segment)
    end
    
    report.metrics :visits
    report.dimensions :hour
    
    @arbitrary_hours = Array.new
    
    report.results.each {|thing| @arbitrary_hours << thing.visits}

    @arbitrary_hours
  end
  
  def reporting_by_hour
      if @reporing_hours.nil?
        @reporting_hours = self.arbitrary_by_hour(@start_date_reporting, @end_date_reporting)
      end    
      @reporting_hours   
  end
  
  def arbitrary_by_day(start_date, end_date)
    #minor report, requires a start_date, end_date
    report = Garb::Report.new($profile.garb,
                              :start_date => start_date,
                              :end_date => end_date)

    if $profile.segment? 
      report.set_segment_id($profile.segment)
    end
    
    report.metrics :visits
    report.dimensions :date
    
    @arbitrary_list = Array.new
    @arbitrary_dates = Array.new
    
    report.results.each {|thing| @arbitrary_list << thing.visits}
    report.results.each {|thing| @arbitrary_dates << thing.date}

    @arbitrary_list
  end
  
  def reporting_by_day
    if @reporing_list.nil?
      @reporting_list = self.arbitrary_by_day(@start_date_reporting, @end_date_reporting)
      @reporting_dates = @arbitrary_dates
    end    
    @reporting_list    
  end
  
  def previous_by_day
    if @previous_list.nil?
      @previous_list = self.arbitrary_by_day(@start_date_previous, @end_date_previous)
      @previous_dates = @arbitrary_dates   
    end    
    @previous_list
  end
  
  def baseline_by_day
    if @baseline_list.nil?
      @baseline_list = self.arbitrary_by_day(@start_date_baseline, @end_date_baseline)
      @baseline_dates = @arbitrary_dates
    end
    @baseline_list
  end
  
  def up_is_nothing?
    false
  end
  
  def up_is_good?
    true
  end
  
  def arbitrary?
    return true
  end
  
end