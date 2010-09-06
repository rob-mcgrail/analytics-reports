class Uniques < Crunch
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

    @monthly_arbitrary = nil
    @monthly_reporting = nil
    @monthly_previous = nil
    @monthly_baseline = nil
    
    @baseline_average = nil
    @previous_change = nil
    @baseline_change = nil
    
    @previous_percentage_change = nil
    @baseline_percentage_change = nil
  end
  
  def to_s
    "#{@all_results}, #{@arbitrary}, #{@reporting}, #{@previous}, #{@baseline}, #{@baseline_percentage}%, #{@monthly_arbitrary}, #{@monthly_reporting}, #{@monthly_previous}, #{@monthly_baseline}, #{@baseline_average}, #{@previous_change}%, #{@baseline_change}%, #{@previous_percentage_change}%, #{@baseline_percentage_change}%, arbitrary? = #{self.arbitrary?}"    
  end

  def three_monthly_averages  
    #main report - prints a basic report for the 3 periods
    #note that the uniques are calculated as an average of months within the period,
    #not as uniques for that period over-all
                                              
    self.monthly_reporting
    self.monthly_previous
    self.monthly_baseline
    
    @previous_percentage_change = percentage_change(@monthly_previous, @monthly_reporting)
    @baseline_percentage_change = percentage_change(@monthly_baseline, @monthly_reporting)

    hash = { :title => "Monthly Uniques", :r =>"#{self.short(@monthly_reporting)}", 
             :p_change => self.to_p(@previous_percentage_change), :p_value =>  "#{self.short(@monthly_previous)}", :p_arrow => self.arrow(@previous_percentage_change),
             :b_change => self.to_p(@baseline_percentage_change), :b_value => "#{self.short(@monthly_baseline)}", :b_arrow => self.arrow(@baseline_percentage_change)}

    @all_results = OpenStruct.new(hash)

    @all_results
  end
  
  def monthly_arbitrary(start_date, end_date, months_in_range)
    #averages out monthly uniques for the period, 
    #rather than returning uniques for the period overall
    #takes $start_date, $end_date, and months_in_range = number of months in the period
        
    @array_of_end_dates = self.get_array_of_months(end_date, months_in_range) 
                                                    #gets array of end_dates
        
    @array_of_start_dates = self.get_array_of_months(end_date.months_ago(1), months_in_range) 
                                                    #gets array of startdates
                                                    #offsets -1 month from passed end_date,  
    uniques = Array.new        
    x = 0
        
    while months_in_range > 0
      uniques << self.arbitrary(@array_of_start_dates[x], @array_of_end_dates[x])
                                                    #cycles through arrays, as arguments
                                                    #for the Uniques.arbitrary method
      x += 1
      months_in_range -= 1
    end
    
    @monthly_arbitrary = uniques.average
  end
  
  def monthly_reporting
    if @monthly_reporting.nil?
      @monthly_reporting = self.monthly_arbitrary(@start_date_reporting, 
                                                  @end_date_reporting, 
                                                  @reporting_number_of_months)
    end
    @monthly_reporting
  end
  
  def monthly_previous
    if @monthly_previous.nil?      
      @monthly_previous = self.monthly_arbitrary(@start_date_previous, 
                                                 @end_date_previous, 
                                                 @reporting_number_of_months)
    end
    @monthly_previous
  end
  
  def monthly_baseline
    if @monthly_baseline.nil?
      @monthly_baseline = self.monthly_arbitrary(@start_date_baseline, 
                                                 @end_date_baseline, 
                                                 @baseline_number_of_months)
    end
    @monthly_baseline
  end
  
  def arbitrary(start_date, end_date)
    #minor report, requires a start_date, end_date
    report = Garb::Report.new($profile.garb,
                              :start_date => start_date,
                              :end_date => end_date)
    
    if $profile.segment? 
      report.set_segment_id($profile.segment)
    end    
    
    report.metrics :visitors
          
    report.results.each {|thing| @arbitrary = thing.visitors}
    @arbitrary.to_i
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
  
  def up_is_nothing?
    return false
  end
  
  def up_is_good?
    return true
  end
  
  def arbitrary?
    return true
  end
 
end
