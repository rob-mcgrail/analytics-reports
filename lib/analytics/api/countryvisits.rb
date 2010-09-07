class CountryVisits 
  include Arrows
  
  attr_reader :all_results
  attr_writer :country
  
  def initialize(country)
    @start_date_reporting = $periods.start_date_reporting
    @end_date_reporting = $periods.end_date_reporting
    @start_date_previous = $periods.start_date_previous
    @end_date_previous = $periods.end_date_previous
    @start_date_baseline = $periods.start_date_baseline
    @end_date_baseline = $periods.end_date_baseline
    @reporting_number_of_months = $periods.reporting_number_of_months
    @baseline_number_of_months = $periods.baseline_number_of_months
    
    @all_results = "You need to run my methods :|"
    
    @country = country
    
    @visit_totals = Visits.new #used for calling visit methods for comparison
                               #with visit totals    
    @arbitrary = nil
    
    @reporting_specific = nil
    @previous_specific = nil
    @baseline_specific = nil
    
    @baseline_else = nil
    @previous_else = nil
    @baseline_else = nil
    
    @reporting_percentage = nil
    @previous_percentage = nil
    @baseline_percentage = nil
    
    @previous_percentage_change = nil
    @baseline_percentage_change = nil
  end
  
  def to_s
    "#{@all_results}, #{@country}, #{@arbitrary}, #{@reporting_specific}, #{@previous_specific}, #{@baseline_specific}, #{@baseline_else}, #{@previous_else}, #{@baseline_else}, #{@reporting_percentage}, #{@previous_percentage}, #{@baseline_percentage}, #{@previous_percentage_change}, #{@baseline_percentage_change} arbitrary? = #{self.arbitrary?}"
  end
  
  def three_with_changes
    #main method percentages, percentage change by baseline, for a country
        
    self.reporting_specific 
    @reporting_percentage = Num.percentage(@reporting_specific, @visit_totals.reporting)
    
    self.previous_specific
    @previous_percentage = Num.percentage(@previous_specific, @visit_totals.previous)
    
    self.baseline_specific  
    @baseline_percentage = Num.percentage(@baseline_specific, @visit_totals.baseline)
    
    self.previous_percentage_change
    self.baseline_percentage_change
    
    hash = { "title" => "#{@country} / International", "r" => "#{Num.short(@reporting_percentage)} / #{Num.short(100 - @reporting_percentage)}%", 
             "p_change" => Num.to_p(@previous_percentage_change), "p_value" => "#{Num.short(@previous_percentage)} / #{Num.short(100 - @previous_percentage)}%", "p_arrow" => self.arrow(@previous_percentage_change),
             "b_change" => Num.to_p(@baseline_percentage_change), "b_value" => "#{Num.short(@baseline_percentage)} / #{Num.short(100 - @baseline_percentage)}%", "b_arrow" => self.arrow(@baseline_percentage_change)}
    
    @all_results = OpenStruct.new(hash)
                            
    @all_results
  end
      
  def arbitrary_specific(start_date, end_date, country = @country)
    #minor report, requires a start_date, end_date and
    #string argument for the country.
    
    report = Garb::Report.new($profile.garb,
                              :start_date => start_date,
                              :end_date => end_date)

    if $profile.segment? 
      report.set_segment_id($profile.segment)
    end

    report.metrics :visits
    report.dimensions :country
      
    countries = Array.new
    visits = Array.new
    
    report.results.each {|entry| countries << entry.country}
    report.results.each {|entry| visits << entry.visits}

    if countries.index(country)==nil #error if country was not returned by analytics
      puts "The country you wanted did not return any visits for this period...?"
    else
      @arbitrary = visits[countries.index(country)] #use .index returned array position from 
                                                    #country array to access corresponding visits 
                                                    #array entry
    end
    @arbitrary
  end
  
  def reporting_specific(country = @country)
    if @reporting_specific.nil?
      @reporting_specific = self.arbitrary_specific(@start_date_reporting, @end_date_reporting, country)
    end
    @reporting_specific.to_i
  end
  
  def previous_specific(country = @country)
    if @previous_specific.nil?
      @previous_specific = self.arbitrary_specific(@start_date_previous, @end_date_previous, country)
    end
    @previous_specific.to_i
  end
  
  def baseline_specific(country = @country)
    if @baseline_specific.nil?
      @baseline_specific = self.arbitrary_specific(@start_date_baseline, @end_date_baseline, country)
    end
    @baseline_specific.to_i
  end
  
  def arbitrary_everything_but(start_date, end_date, country = @country)
    #minor report, requires a start_date, end_date and
    #string argument for the country desired.
    #opposite of CountryVisits.specific - returns total of 
    #visits from all countries but the one returned
    
    #serves no real purpose at the moment...
    
    report = Garb::Report.new($profile.garb,
                              :start_date => start_date,
                              :end_date => end_date)
    
    if $profile.segment? 
      report.set_segment_id($profile.segment)
    end
    
    report.metrics :visits
    report.filters :country.not_eql => country
    
    report.results.each {|thing| @arbitrary = thing.visits}
    @arbitrary
  end
  
  def reporting_everything_but(country = @country)
    if @reporting_else.nil?
      @reporting_else = self.arbitrary_everything_but(@start_date_reporting, @end_date_reporting, country)
    end
    @reporting_else.to_i
  end
  
  def previous_everything_but(country = @country)
    if @previous_else.nil?
      @previous_else = self.arbitrary_everything_but(@start_date_previous, @end_date_previous, country)
    end
    @previous_else.to_i
  end
  
  def baseline_everything_but(country = @country)
    if @baseline_else.nil?
      @baseline_else = self.arbitrary_everything_but(@start_date_baseline, @end_date_baseline, country)
    end
    @baseline_else.to_i
  end
  
  def previous_percentage_change
    if @previous_percentage.nil?
      @previous_percentage = percentage(self.previous, @visit_totals.previous)
    end
    
    if @reporting_percentage.nil?
      @reporting_percentage = percentage(self.baseline, @visit_totals.reporting)
    end
    
    @previous_percentage_change = percentage_change(@previous_percentage, @reporting_percentage)
  end
  
  def baseline_percentage_change
    if @baseline_percentage.nil?
      @baseline_percentage = percentage(self.baseline, @visit_totals.baseline)
    end
    
    if @reporting_percentage.nil?
      @reporting_percentage = percentage(self.baseline, @visit_totals.reporting)
    end
    
    @baseline_percentage_change = percentage_change(@baseline_percentage, @reporting_percentage)
  end
  
  def up_is_nothing?
    return true
  end
  
  def arbitrary?
    return false
  end
  
end
