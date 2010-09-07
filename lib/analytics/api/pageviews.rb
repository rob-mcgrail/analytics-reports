class PageViews 
  include Arrows
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
    
    @visit_totals = Visits.new
    
    @previous_change = nil
    @baseline_change = nil
  end
  
  def to_s
    "#{@all_results}, #{@arbitrary}, #{@reporting}, #{@previous}, #{@baseline}, #{@previous_change}%, #{@baseline_change}%, arbitrary? = #{self.arbitrary?}"
  end
  
  def three_with_changes_per_visit
    self.reporting
    self.previous
    self.baseline
    
    per_visits_reporting = @reporting.to_f / @visit_totals.reporting.to_f
    per_visits_previous = @previous.to_f / @visit_totals.previous.to_f
    per_visits_baseline = @baseline.to_f / @visit_totals.baseline.to_f
    
    @previous_change = Num.percentage_change(per_visits_previous, per_visits_reporting)
    @baseline_change = Num.percentage_change(per_visits_baseline, per_visits_reporting)
                    
    hash = { :title => "Pages / Visit", :r => Num.short(per_visits_reporting, 2), 
             :p_change => Num.to_p(@previous_change), :p_value => Num.short(per_visits_previous, 2), :p_arrow => self.arrow(@previous_change),
             :b_change => Num.to_p(@baseline_change), :b_value => Num.short(per_visits_baseline, 2), :b_arrow => self.arrow(@baseline_change)}

    @all_results = OpenStruct.new(hash)
    
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

    report.metrics :pageviews
          
    report.results.each {|thing| @arbitrary = thing.pageviews}
    @arbitrary.to_i
  end
  
  def arbitrary_page(path, start_date = @start_date_reporting, end_date = @end_date_reporting)
    #gets a single number for a single page
    report = Garb::Report.new($profile.garb,
                              :start_date => start_date,
                              :end_date => end_date)

    if $profile.segment? 
      report.set_segment_id($profile.segment)
    end
    
    report.metrics :pageviews
    
    report.filters do
      contains(:pagePath, path)
    end
    
    report.filters do
      contains(:pagePath, path.downcase)  #for domains that have capitalized and non capitalized instances in their history
    end
    
    report.filters do
      contains(:pagePath, path.downcase.gsub("-", "_"))  #for changes in how spaces are handled...
    end
    
    @arbitrary = 0
    report.results.each {|thing| @arbitrary = thing.pageviews}
    @arbitrary.to_i  
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
    @previous    
  end
  
  def baseline
    if @baseline.nil?
      @baseline = self.arbitrary(@start_date_baseline, @end_date_baseline)
    end
    @baseline    
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