class NewVisits < Crunch
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
    
    @visit_totals = Visits.new #used for calling visit methods for comparison
                               #with visit totals
    
    @arbitrary = nil
    @reporting = nil
    @previous = nil
    @baseline = nil
    
    @baseline_average = nil
    @previous_change = nil
    @baseline_change = nil
    
    @reporting_percentage = nil
    @previous_percentage = nil
    @baseline_percentage = nil
    
    @previous_percentage_change = nil
    @baseline_percentage_change = nil
  end
  
  def to_s
    "#{@all_results}, #{@arbitrary}, #{@reporting}, #{@previous}, #{@baseline}, #{@baseline_average}, #{@previous_change}%, #{@baseline_change}%, #{@reporting_percentage}%, #{@previous_percentage}%, #{@baseline_percentage}%, #{@previous_percentage_change}%, #{@baseline_percentage_change}%, arbitrary? = #{self.arbitrary?}"
  end
  
  def three_with_changes
    #main method returns new, returning and baseline visits ammounts, 
    #and baseline percentage change
    
    self.reporting_percentage
    
    self.previous_percentage  
    
    self.baseline_percentage
    
    self.baseline_percentage_change
    self.previous_percentage_change

    hash = {:title => "New/Returning", :r =>"#{self.short(reporting_percentage)} / #{self.short(100 -  reporting_percentage)}%", 
            :p_change => self.to_p(@previous_percentage_change), :p_value => "#{self.short(previous_percentage)} / #{self.short(100 -  previous_percentage)}%", :p_arrow => self.arrow(@previous_percentage_change),
            :b_change => self.to_p(@baseline_percentage_change), :b_value => "#{self.short(baseline_percentage)} / #{self.short(100 -  baseline_percentage)}%", :b_arrow => self.arrow(@baseline_percentage_change)}

    @all_results = OpenStruct.new(hash)
    
    @all_results
  end
  
  def reporting_only #made for the hubs report
    self.reporting_percentage
    
    @all_results = ["New / Returning", "#{self.short(reporting_percentage)}", "#{self.short(100 - reporting_percentage)}"]
    
    @all_results
  end
  
  
  def arbitrary(start_date, end_date)
    #minor report, requires a start_date, end_date
    report = Garb::Report.new($profile.garb,
                              :start_date => start_date,
                              :end_date => end_date)

    if $profile.segment? 
      report.set_segment_id($profile.segment)
    end

    report.metrics :newVisits
            
    report.results.each {|thing| @arbitrary = thing.new_visits}
    @arbitrary.to_i
  end
    
  def baseline_average
    if @baseline_average.nil?
      @baseline_average = self.average_by_period
    end
    @baseline_average
  end

  def reporting_percentage
    if @reporting_percentage.nil?
      @reporting_percentage = percentage(self.reporting, @visit_totals.reporting)
    end
    @reporting_percentage
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
  
  def previous_percentage
    if @previous_percentage.nil?
      @previous_percentage = percentage(self.previous, @visit_totals.previous)
    end
    @previous_percentage
  end
  
  def previous_percentage_change
    if @previous_percentage.nil?
      @previous_percentage = percentage(self.previous, @visit_totals.previous)
    end
    
    if @reporting_percentage.nil?
      @reporting_percentage = percentage(self.reporting, @visit_totals.reporting)
    end
    
    @previous_percentage_change = percentage_change(@previous_percentage, @reporting_percentage)
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
  
  def baseline_percentage
    if @baseline_percentage.nil?
      @baseline_percentage = percentage(self.baseline, @visit_totals.baseline)
    end
    @baseline_percentage
  end
  
  def baseline_percentage_change
    if @baseline_percentage.nil?
      @baseline_percentage = percentage(self.baseline, @visit_totals.baseline)
    end
    
    if @reporting_percentage.nil?
      @reporting_percentage = percentage(self.reporting, @visit_totals.reporting)
    end
    
    @baseline_percentage_change = percentage_change(@baseline_percentage, @reporting_percentage)
  end
  
  def reporting
    if @reporting.nil?
      @reporting = self.arbitrary(@start_date_reporting, @end_date_reporting)
    end
    @reporting
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
    return true
  end
  
  def arbitrary?
    return true
  end

end