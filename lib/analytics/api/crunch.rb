class Crunch  
  #The parent class for reporting logic
 
  def percentage(given, total)
    given = given.to_f
    total = total.to_f
    
    if total == 0
      puts "Error - you're using Crunch.percentage to create a percentage of 0!\nI will return 9999999999.\n"
      return 9999999999
    end
    
    (given/total)*100
  end

  def percentage_change(a, b)
    a = a.to_f
    b = b.to_f
    
    ((b-a)*100) / a
  end
  
  def to_p (num, precision=0)
    	"%.#{precision}f" % num + "%"
  end
  
  def short (num, precision=0)
    	"%.#{precision}f" % num
  end

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
  
  def make_visits_percentages_of_total(start_date, end_date)
    #takes start_date and end_date,
    #returns an array of visit percentage floats,
    #depends on there to be a @list_visits array in the instance
  
    total = Visits.new.arbitrary(start_date, end_date)
    @visits_as_percent = Array.new
    
    @list_visits.each do |thing|
      @visits_as_percent << percentage(thing, total)
    end
    
    @visits_as_percent
  end
  
  def make_bounces_rates
      #takes start_date and end_date,
      #returns an array of bounce rates as floats,
      #depends on there to be a @list_bounces and list_visits array in the instance
  
      @rates = Array.new    
      
      if @list_visits.length != @list_bounces.length
        raise "The two arrays you are using in Crunch.make_bounces_rates are not of the same length!"
      end
      
      i = @list_visits.length
      x = 0
      while i > 0
        @rates << percentage(@list_bounces[x], @list_visits[x])
        i = i - 1
        x = x + 1
      end
  
      @rates
    end
    
  def make_times_average_sessions
    #takes start_date and end_date,
    #returns an array of average session times as floats in seconds,
    #depends on there to be a @list_times + list_visits array in the instance
    
    @average_sessions = Array.new
    
    if @list_visits.length != @list_times.length
      raise "The two arrays you are using in Crunch.make_times_average_sessions are not of the same length!"
    end
    
    i = @list_visits.length
    x = 0
    while i > 0
      @average_sessions << @list_times[x].to_f / @list_visits[x].to_f
      i = i - 1
      x = x + 1
    end
    
    @average_sessions
  end
  
  def make_seconds(times)
    #takes a float, int or array of same
    #converts numbers in to seconds
    #use thing.strftime("%M:%S") or similar to then print
    #try and do this last... because other methods expect numbers, not
    #times (ie percentage change, average, etc...)
    #check the test/crunch script for more
    
    @time_holder = Array.new
    
    if times.is_a?(Array)
      
      times.each do |thing|
        thing = Time.at(thing)
        @time_holder << thing
      end
      
      times = Array.new
      @time_holder.each {|thing| times << thing}
      times
    else
      if times.is_a?(Float) #this was then needed because nan? doesn't work for integers...
        if times.nan? # this was necessary to stop some error on periods with no values (ie newish content)
          times = 0
        end
      end
      times = Time.at(times.to_i)
    end
    times
  end
  
  def arrow(change)
    # sets orientation and color of arrows for results
    # each data class method is expected to have bool values for
    # up_is_nothing? (not good or bad, so grey) and up_is_good? (whether it is green or red)
    # to see how this works check the test/crunch script

    change = change.to_f

    if change == 0
      @arrow = $format.equals
      return @arrow
    end
      
    if change > 0
      if self.up_is_nothing?
        @arrow = $format.grey_up
        return @arrow
      end
      if self.up_is_good?
        @arrow = $format.green_up
      else
        @arrow = $format.red_up
      end
      
    else
      if self.up_is_nothing?
        @arrow = $format.grey_down
        return @arrow
      end
      if self.up_is_good?
        @arrow = $format.red_down
      else
        @arrow = $format.green_down
      end

    end
    
  end
  
  def arrow?
    #helpful for debugging...
    puts @arrow
  end
  
  def arbitrary?
    puts "The .arbitrary? call you made was to Crunch, not a child of Crunch!"
    return false
  end
  
end



