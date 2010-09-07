module StatGetters
  def make_visits_percentages_of_total(start_date, end_date)
    #takes start_date and end_date,
    #returns an array of visit percentage floats,
    #depends on there to be a @list_visits array in the instance
  
    total = Visits.new.arbitrary(start_date, end_date)
    @visits_as_percent = Array.new
    
    @list_visits.each do |thing|
      @visits_as_percent << Num.percentage(thing, total)
    end
    
    @visits_as_percent
  end
  
  def make_bounces_rates
      #returns an array of bounce rates as floats,
      #depends on there to be a @list_bounces and list_visits array in the instance
  
      @rates = Array.new    
      
      if @list_visits.length != @list_bounces.length
        raise "The two arrays you are using in Crunch.make_bounces_rates are not of the same length!"
      end
      
      i = @list_visits.length
      x = 0
      while i > 0
        @rates << Num.percentage(@list_bounces[x], @list_visits[x])
        i = i - 1
        x = x + 1
      end
  
      @rates
    end
    
  def make_times_average_sessions
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
end