module DateHelper

  #a mixin for api classes that have to crunch a lot of dates

  def get_array_of_months(date, months_in_range)
    #returns an array of dates, one month apart.
    #used for getting a range of months from within a date-range
    #date = the last date; months_in_range = the ammount of months in the date-range


    @dates = Array.new

    months_in_range-=1 #offset because first value is added seperately at the end
    while months_in_range > 0
      @dates << date.months_ago(months_in_range)
      months_in_range-=1
    end


    @dates << date #first date is returned unchanged

    @dates.reverse!

    @dates
  end

  def inspect_array_of_months(date, months_in_range)

    #used to inspect this sort of scary method - to confirm things are right
    #runs itself and prints out it's values

    #there's also a test for this in test/crunch

    dates = self.get_array_of_months(date, months_in_range, start)

    dates.each {|thing| puts thing}

  end

  def get_array_of_arbitrary_month_intervals(date,
                                             months_in_range = @baseline_number_of_months,
                                             month_interval = @reporting_number_of_months,
                                             start = nil)

    #returns an array of dates, x months apart.
    #used like get_array_of_months
    #date = the last date; months_in_range = the ammount of months in the date-range
    #month_interval = the desired ammount of months between dates
    #standard arguments since this tends to only get used in one way...

    #if passed a non-nill final argument, offsets date by 1 day, making for good startdates for
    #a pair of arrays, so the various periods don't have overlapping days

    if start != nil
      date = date.tomorrow
    end

    @dates = Array.new

    @dates << date #first date is returned unchanged

    intervals_in_range = months_in_range/month_interval #setting correct ammount of dates to collect
    intervals_in_range-=1 #offset because first value is already entered

    while intervals_in_range > 0
      @dates << date.months_ago(month_interval)
      date = date.months_ago(month_interval)
      intervals_in_range-=1
    end

    @dates
  end

  def inspect_array_of_arbitrary_month_intervals(date,
                                                 months_in_range = @baseline_number_of_months,
                                                 month_interval = @reporting_number_of_months,
                                                 start = nil)

    #used to inspect this sort of scary method - to confirm things are right
    #runs itself and prints out it's values
    #there's also a test for this in test/crunch

    dates = self.get_array_of_arbitrary_month_intervals(date, months_in_range, month_interval)

    dates.each {|thing| puts thing}

  end

  def average_by_period(end_date = @end_date_baseline,
                        months_in_range = @baseline_number_of_months,
                        month_interval = @reporting_number_of_months)

    #used to calculate average for some monthly interval,
    #within a reporting period (ie baseline)
    #takes a start and end date, months_in_range = number of months in the period
    #month_interval = number of months to calculate the averages by
    #(this will generally be the ammount of months in the reporting period)
    #needs there to be a method called arbitrary that gets the desired result

    #quick test for arbitrary method
    if self.arbitrary? != true
      raise "Error - invoking method that depends on 'arbitrary' method, from an object that doesn't have one!"
    end

    @array_of_end_dates = self.get_array_of_arbitrary_month_intervals(end_date,
                                                                      months_in_range,
                                                                      month_interval)
                            #gets array of end_dates

    @array_of_start_dates = self.get_array_of_arbitrary_month_intervals(end_date.months_ago(month_interval),
                                                                        months_in_range,
                                                                        month_interval,
                                                                        1)
                            #gets array of startdates
                            #offsets by whatever ammount of months is being
                            #used as the average's period
                            #offsets by a day with final "start = 1" argument

    @temporary_results = Array.new #this is an instance variable so it can be visible to test script... long story...

    #quick check that arguments are good
    if months_in_range < month_interval
      raise "The range is shorter than the interval... think harder about your arguments :|"
    end

    x = 0
    months_in_range = months_in_range/month_interval #setting correct ammount of dates to collect

    while months_in_range > 0

      @temporary_results << self.arbitrary(@array_of_start_dates[x], @array_of_end_dates[x])
                          #cycles through arrays, as arguments
                          #passed to self.arbitrary method (in calling class)
      x += 1
      months_in_range -= 1
    end

    result = @temporary_results.average
    result
  end

  def inspect_average_by_period(end_date = @end_date_baseline,
                                months_in_range = @baseline_number_of_months,
                                month_interval = @reporting_number_of_months)

    #used to inspect this sort of scary method - to confirm things are right
    #runs itself and prints out it's values
    #there's also a test for this in test/crunch

    result = self.average_by_period

    x = @array_of_start_dates.length - 1

    puts"Dates"
    while x >= 0
      puts "#{@array_of_start_dates[x]}-#{@array_of_end_dates[x]}"
      x-=1
    end

    puts "Results"
    @temporary_results.each {|thing| puts thing}

    puts "Result"
    puts result
  end
end

