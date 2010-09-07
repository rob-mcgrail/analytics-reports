class Depth 
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
    @depth_arbitrary = Array.new
    
  end
  
  def to_s
    "#{@all_results}, #{@arbitrary}, #{@reporting}, #{@previous}, #{@baseline}, arbitrary? = #{self.arbitrary?}"    
  end
  
  def basic_five
    
    self.reporting(5)
    
    @all_results = ["1 page = #{@reporting[0]}",
                    "2 pages = #{@reporting[1]}",
                    "3 pages = #{@reporting[2]}",
                    "4 pages = #{@reporting[3]}",
                    ">4 pages = #{@reporting[4]}"]
    @all_results
  end
  
  def reporting(cap = 5)
    self.arbitrary(@start_date_reporting, @end_date_reporting)
    @reporting = self.sort(@visits_arbitrary, @depth_arbitrary, cap)
  end
  
  def previous(cap = 5)
    self.arbitrary(@start_date_previous, @end_date_previous)
    @previous = self.sort(@visits_arbitrary, @depth_arbitrary, cap)
  end
  
  def baseline(cap = 5)
    self.arbitrary(@start_date_baseline, @end_date_baseline)
    @baseline = self.sort(@visits_arbitrary, @depth_arbitrary, cap)
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
    report.dimensions :pageDepth
    
    @visits_arbitrary = Array.new
    @depth_arbitrary = Array.new
            
    report.results.each {|thing| @visits_arbitrary << thing.visits.to_i}
    report.results.each {|thing| @depth_arbitrary << thing.page_depth.to_i}
  end
  
  def sort(visits = @visits_arbitrary, depth = @depth_arbitrary, cap = 5)
    #sorts the results from arbitrary
    #takes the visits and depth arrays from arb,
    #and the cap is how many values you need
    #has a test in test/loyalty
    
    @arbitrary = Array.new
    x = 1
    
    while x < cap
      
      if depth.index(x) != nil                
        @arbitrary << visits[depth.index(x)]
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