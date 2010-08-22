class Loyalty < Crunch
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
    
    @arbitrary = [nil]
    @reporting = [nil]
    @previous = [nil]
    @baseline = [nil]
    
    @visits_arbitrary = Array.new
    @count_arbitrary = Array.new
    
  end
  
  def to_s
    "#{@all_results}, #{@arbitrary}, #{@reporting}, #{@previous}, #{@baseline}, arbitrary? = #{self.arbitrary?}"    
  end
  
  def basic_five
    
    self.reporting(5)
    
    @all_results = ["1 time = #{@reporting[0]}",
                    "2 times = #{@reporting[1]}",
                    "3 times = #{@reporting[2]}",
                    "4 times = #{@reporting[3]}",
                    ">4 times = #{@reporting[4]}"]
    @all_results
  end
  
  def reporting(cap = 5)
    self.arbitrary(@start_date_reporting, @end_date_reporting)
    @reporting = self.sort(@visits_arbitrary, @count_arbitrary, cap)
  end
  
  def previous(cap = 5)
    self.arbitrary(@start_date_previous, @end_date_previous)
    @previous = self.sort(@visits_arbitrary, @count_arbitrary, cap)
  end
  
  def baseline(cap = 5)
    self.arbitrary(@start_date_baseline, @end_date_baseline)
    @baseline = self.sort(@visits_arbitrary, @count_arbitrary, cap)
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
    report.dimensions :visitCount
    
    @visits_arbitrary = Array.new
    @count_arbitrary = Array.new
            
    report.results.each {|thing| @visits_arbitrary << thing.visits.to_i}
    report.results.each {|thing| @count_arbitrary << thing.visit_count.to_i}
    
  end
  
  def sort(visits = @visits_arbitrary, count = @count_arbitrary, cap = 5)
    #sorts the results from arbitrary
    #takes the visits and count arrays from arb,
    #and the cap is how many values you need
    
    @arbitrary = Array.new
    x = 1
    
    while x < cap
      
      if count.index(x) != nil                
        @arbitrary << visits[count.index(x)]
        x = x + 1
      else
        @arbitrary << 0
        x = x + 1
      end
    
    end

    not_remainder = @arbitrary.sum
            
    greater_than = visits.sum - not_remainder
        
    @arbitrary << greater_than.to_i
    @arbitrary
  end
  
  def up_is_nothing?
    return true
  end

  def arbitrary?
    return false #there is one, but it wont be useful to the usual arbitrary Crunch calls
  end
  
end