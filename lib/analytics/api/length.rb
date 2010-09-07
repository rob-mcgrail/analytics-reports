class Length 
  attr_reader :all_results
  attr_accessor :big_site
  
  #
  #Returns the Length of visit bar graph
  #
  
  #
  #change @big_site from true in order to stop the default filtering out of 
  #single visit values (this appears to be how the GA web interface does it too)
  #you want to filter where-ever the request will return more than 1000 individual lengths
  #
  
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
    
    @zero_ten = Array.new
    @eleven_thirty = Array.new
    @thirtyone_sixty = Array.new
    @sixtyone_oneeighty = Array.new
    @oneeightyone_plus = Array.new
    
    @big_site = true #filter small values from big sites by default for acurate results

  end
  
  def to_s
    "#{@all_results}, #{@arbitrary}, #{@reporting}, #{@previous}, #{@baseline}, #{@zero_ten}, #{@eleven_thirty}, #{@thirtyone_sixty}, #{@sixtyone_oneeighty}, #{@oneeightyone_plus}, arbitrary? = #{self.arbitrary?}"
  end
  
  def basic_five_reporting
    
    self.reporting
    
    @all_results = ["0-10 = #{@reporting[0].to_i}",
                    "11-30 = #{@reporting[1].to_i}",
                    "31-60 = #{@reporting[2].to_i}",
                    "61-180 = #{@reporting[3].to_i}",
                    "180+ = #{@reporting[4].to_i}"]
    @all_results
  end
  
  def reporting
    @reporting = self.arbitrary(@start_date_reporting, @end_date_reporting)
  end
  
  def arbitrary(start_date, end_date)
    #minor report, requires a start_date, end_date
    
    report = Garb::Report.new($profile.garb,
                              :start_date => start_date,
                              :end_date => end_date)

    if $profile.segment? 
      report.set_segment_id($profile.segment)
    end
    
    if @big_site==true
      report.filters :visits.gt => 1
    end
    
    report.metrics :visits
    report.dimensions :visitLength
    

    
    @zero_ten = Array.new
    @eleven_thirty = Array.new
    @thirtyone_sixty = Array.new
    @sixtyone_oneeighty = Array.new
    @oneeightyone_plus = Array.new
            
    report.results.each do |thing|
      if thing.visit_length.to_i >= 0
        if thing.visit_length.to_i < 11
          @zero_ten << thing.visits.to_i
        end
      end
      if thing.visit_length.to_i > 10
        if thing.visit_length.to_i < 31
          @eleven_thirty << thing.visits.to_i
        end
      end
      if thing.visit_length.to_i > 30
        if thing.visit_length.to_i < 61
          @thirtyone_sixty << thing.visits.to_i
        end
      end
      if thing.visit_length.to_i > 60
        if thing.visit_length.to_i < 181
          @sixtyone_oneeighty << thing.visits.to_i
        end
      end
      if thing.visit_length.to_i > 180
        @oneeightyone_plus << thing.visits.to_i
      end
    end
    
    @arbitrary = Array.new
    
    @arbitrary << @zero_ten.sum
    @arbitrary << @eleven_thirty.sum
    @arbitrary << @thirtyone_sixty.sum
    @arbitrary << @sixtyone_oneeighty.sum
    @arbitrary << @oneeightyone_plus.sum
    
    @arbitrary 
  end
  
  
  def up_is_nothing?
    return true
  end

  def arbitrary?
    return false #there is one, but it wont be useful to the usual arbitrary Crunch calls
  end
  
end