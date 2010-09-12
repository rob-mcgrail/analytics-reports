class BounceRate
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

    @all_results = "You need to run my methods :|"

    @arbitrary = nil
    @reporting = nil
    @previous = nil
    @baseline = nil

    @reporting_filtered = nil
    @previous_filtered = nil
    @baseline_filtered = nil

    @bounces = nil
    @visits = nil

    @previous_change = nil
    @baseline_change = nil
  end

  def to_s
    "#{@all_results}, #{@arbitrary}, #{@reporting}, #{@previous}, #{@baseline}, #{@reporting_filtered}, #{@previous_filtered}, #{@baseline_filtered}, #{@bounces}, #{@visits}, #{@previous_change}, #{@baseline_change} arbitrary? = #{self.arbitrary?}"
  end

  def three_with_changes_by_path(path)
    #a main report - provides a basic report over 3 periods
    #takes a string argument for filtering result by paths (using arbitrary_by_path)

    self.reporting_by_path(path)
    self.previous_by_path(path)
    self.baseline_by_path(path)

    @previous_change = Num.percentage_change(@previous_filtered, @reporting_filtered)
    @baseline_change = Num.percentage_change(@baseline_filtered, @reporting_filtered)

    if path == "/" #make homepage path obvious
      path = "homepage"
    end

    hash = {:title => "Bounce rate", :r => Num.to_p(@reporting_filtered),
            :p_change => Num.to_p(@previous_change), :p_value => Num.to_p(@previous_filtered), :p_arrow => self.arrow(@previous_change),
            :b_change => Num.to_p(@baseline_change), :b_value => Num.to_p(@baseline_filtered), :b_arrow => self.arrow(@baseline_change)}

    @all_results = OpenStruct.new(hash)

    @all_results
  end

  def three_with_changes
    #a main report - provides a basic report over 3 periods
    #use all_results_by_path instead for filtering by page

    self.reporting
    self.previous
    self.baseline

    @previous_change = Num.percentage_change(@previous, @reporting)
    @baseline_change = Num.percentage_change(@baseline, @reporting)

    hash = {:title => "Bounce rate", :r => Num.to_p(@reporting),
            :p_change => Num.to_p(@previous_change), :p_value => Num.to_p(@previous), :p_arrow => self.arrow(@previous_change),
            :b_change => Num.to_p(@baseline_change), :b_value => Num.to_p(@baseline), :b_arrow => self.arrow(@baseline_change)}

    @all_results = OpenStruct.new(hash)

    @all_results
  end

  def arbitrary_by_path(start, finish, path)
    #minor report, requires a start_date, end_date, and string path for filtering

    report = Garb::Report.new($profile.garb,
                              :start_date => start,
                              :end_date => finish)

    if $profile.segment?
      report.set_segment_id($profile.segment)
    end

    report.metrics :bounces, :visits
    report.filters :page_path.eql => path

    report.results.each {|thing| @bounces = thing.bounces}
    report.results.each {|thing| @visits = thing.visits}

    @arbitrary = Num.percentage(@bounces, @visits)
  end

  def reporting_by_path(path)
    if @reporting_filtered.nil?
      @reporting_filtered = self.arbitrary_by_path(@start_date_reporting, @end_date_reporting, path)
    end
    @reporting_filtered.to_i
  end

  def previous_by_path(path)
    if @previous_filtered.nil?
      @previous_filtered = self.arbitrary_by_path(@start_date_previous, @end_date_previous, path)
    end
    @previous_filtered.to_i
  end

  def baseline_by_path(path)
    if @baseline_filtered.nil?
      @baseline_filtered = self.arbitrary_by_path(@start_date_baseline, @end_date_baseline, path)
    end
    @baseline_filtered.to_i
  end

  def arbitrary(start, finish)
    #minor report, requires a start_date, end_date

    report = Garb::Report.new($profile.garb,
                              :start_date => start,
                              :end_date => finish)

    if $profile.segment?
      report.set_segment_id($profile.segment)
    end

    report.metrics :bounces, :visits

    report.results.each {|thing| @bounces = thing.bounces}
    report.results.each {|thing| @visits = thing.visits}

    @arbitrary = Num.percentage(@bounces, @visits)
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
    false
  end

  def up_is_good?
    false
  end

  def arbitrary?
    return true
  end

end

