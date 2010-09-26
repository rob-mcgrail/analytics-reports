module Num

  def Num.percentage(given, total)
    given = given.to_f
    total = total.to_f

    if total == 0
      puts "Error - you're using Crunch.percentage to create a percentage of 0!\nI will return 9999999999.\n"
      return 9999999999
    end

    (given/total)*100
  end

  def Num.percentage_change(a, b)
    a = a.to_f
    b = b.to_f

    ((b-a)*100) / a
  end

  def Num.round_up(number)
    divisor = 10**Math.log10(number).floor
    i = number / divisor
    remainder = number % divisor
    if remainder == 0
      i * divisor
    else
      (i + 1) * divisor
    end
  end


  def Num.to_p (num, precision=0)
      if num == nil
        return 0
      else
    	  "%.#{precision}f" % num + "%"
    	end
  end

  def Num.short (num, precision=0)
    	"%.#{precision}f" % num
  end

  def Num.make_seconds(times)
    #takes a float, int or array of same
    #converts numbers in to seconds
    #use thing.strftime("%M:%S") or similar to then print
    #try and do this last... because other methods expect numbers, not
    #times (ie percentage change, average, etc...)

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
  
  
end

