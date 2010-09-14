class Content
  attr_reader :all_results, :results_arbitrary, :by_time, :by_views
  attr_accessor :limit

  #
  # To use this class effectively, you need to run the method .calculate_limit, or set a limit with
  # the setter method, in order to filter out appropriately, low pageviews pages from the
  # ordered by time view.
  #
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

    @results_arbitrary = ["You need to run my methods :|"]

    @by_time = ["You need to run my methods :|"]
    @by_views = ["You need to run my methods :|"]

    @limit = 0

  end

  def to_s
    "#{@all_results}, #{@arbitrary}, #{@reporting}, #{@previous}, #{@baseline}, #{@results_arbitrary}, #{@pageviews_arbitrary}, #{@path_arbitrary}, #{@time_arbitrary},  arbitrary? = #{self.arbitrary?}"
  end

  def ordered_by_time(start_date, end_date, ammount = 10)

    self.arbitrary(start_date, end_date)

    @results_arbitrary = self.order_by_time(@results_arbitrary)

    temp = Array.new

    @results_arbitrary.each do |thing|                      #filter by limit
      if thing.pageviews > @limit
        temp << thing
      end
    end
    @results_arbitrary = temp

    @results_arbitrary = @results_arbitrary.first(ammount)  #peel off the top 10 or so

    rows = Array.new

    @results_arbitrary.each do |thing|
      a = Array.new
      thing.time = Num.make_seconds(thing.time) #make in to seconds
      a << "#{thing.page_path}"                 #add in page path
      a << "#{thing.pageviews}"                 #add in pageviews
      a << "#{thing.time.strftime("%M:%S")}"    #add in time

      rows << a
    end

    header = ["Page", "Pageviews", "Avg session"]

    hash = { :title => "Most engaging content", :table_id => "engagement", :header => header, :rows => rows }

    @by_time = OpenStruct.new(hash)
    @by_time
  end

  def ordered_by_pageviews(start_date, end_date, ammount = 10)

    self.arbitrary(start_date, end_date)

    @results_arbitrary = self.order_by_pageviews(@results_arbitrary)  #order by pageviews
    @results_arbitrary = @results_arbitrary.first(ammount)            #peel off top 10 or so

    rows = Array.new

    @results_arbitrary.each do |thing|
      a = Array.new
      thing.time = Num.make_seconds(thing.time) #make in to seconds
      a << "#{thing.page_path}"                 #pagepath
      a << "#{thing.pageviews}"                 #pageviews
      a << "#{thing.time.strftime("%M:%S")}"    #add in time

      rows << a
    end

    header = ["Page", "Pageviews", "Avg session"]

    hash = { :title => "Most popular content", :table_id => "popular", :header => header, :rows => rows }

    @by_pageviews = OpenStruct.new(hash)
    @by_pageviews
  end

  def arbitrary(start_date, end_date)
    #minor report, requires a start_date, end_date, and can take a limit
    #to filter the results for tiny values

    #
    #   you need to test the shit out of this....
    #
    #

    report = Garb::Report.new($profile.garb,
                              :start_date => start_date,
                              :end_date => end_date)

    if $profile.segment?
      report.set_segment_id($profile.segment)
      if $profile.segment_string?

        report.filters do
          contains(:pagePath, $profile.segment_string)
        end

        report.filters do
          contains(:pagePath, $profile.segment_string.downcase)
          #for domains that have capitalized and non capitalized instances in their history
        end

        report.filters do
          contains(:pagePath, $profile.segment_string.downcase.gsub("-", "_"))  #for changes in how spaces are handled...
        end

      end
    elsif
      if $profile.segment_string?
        report.filters do
          contains(:pagePath, $profile.segment_string)
        end

        report.filters do
          contains(:pagePath, $profile.segment_string.downcase)
          #for domains that have capitalized and non capitalized instances in their history
        end

        report.filters do
          contains(:pagePath, $profile.segment_string.downcase.gsub("-", "_"))  #for changes in how spaces are handled...
        end

      end
    else
      $display << "You seem to have not passed a segment or segment string argument into content.\nThis is probably ok, unless you want Content to be by-segment or limited to a part of the site\n"
    end

    report.metrics :timeOnPage, :pageviews, :exits
    report.dimensions :pagePath
    report.sort :timeOnPage.desc


    @results_arbitrary = Array.new

    report.results.each do |thing|

      views = thing.pageviews.to_i-thing.exits.to_i #adjusting the pageviews so they can be used to calculate session times

      if views == 0
        if @limit != 0 #this makes sure it isn't just being called by the calculate_limit method
          time = 0
        else
          time = 0
        end
      else
        time = thing.time_on_page.to_i/views            #metric by views
      end                                               #then make in to hash, openstruct,
                                                        #then place in array

      hash = { "page_path" => thing.page_path, "pageviews" => thing.pageviews.to_i, "time" => time.to_i}

      @results_arbitrary << OpenStruct.new(hash) #make in to array
    end
    @results_arbitrary
  end

  #
  #  these below are not perfect... make !Array?
  #

  def calculate_limit(start_date, end_date)

    self.arbitrary(start_date, end_date)

    ave = Array.new
    @results_arbitrary.each {|thing| ave << thing.pageviews}

    x = ave.average

    @limit = x/1.2

    @limit = @limit.to_i

    @limit
  end

  def order_by_time(results = @results_arbitrary) #sort by time
    if !results.is_a? Array
      raise "Error - Trying to use a method for ordering arrays, but you sent something else..."
    end
    results = results.sort_by { |a| a.time }
    results.reverse!
    results
  end

  def order_by_pageviews(results = @results_arbitrary)  #sort by pageviews
    if !results.is_a? Array
      raise "Error - Trying to use a method for ordering arrays, but you sent something else..."
    end
    results = results.sort_by { |a| a.pageviews }
    results.reverse!
    results
  end

  def up_is_nothing?
    return true
  end

  def arbitrary?
    return false #there is one, but it wont be useful to the usual arbitrary Crunch calls
                 #especially as it returns an array of ostructs instead of just an array...
  end

end

