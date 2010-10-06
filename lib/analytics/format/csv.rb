class CSV < Format


  def initialize
    if !defined? $collector
      $display << "The collector is not defined. I am instantiating it now..."
      $collector = OpenStruct.new #this will be initialized by whichever object gets there first
      $collector.output = String.new #this is so there is always an easy compatible print method in report classes
      
    end

    #set values for arrows

    @green_up = "green_up"
    @green_down = "green_down"
    @red_up = "red_up"
    @red_down = "red_down"
    @grey_up = "grey_up"
    @grey_down = "grey_down"
    @equals = "equals"

    @collector = String.new #this is the local collector
                            #to 'go global', run self.finish

  end

  def header(columns) #pass an array of the colums...

    x = columns.length
    i = 0
    
    while x > 1
      @collector << "#{columns[i]}, "
      i+=1
      x-=1
    end
    
    @collector << "#{columns[i]}\n"
    
  end
  
  def values(values)
    
    x = values.length
    i = 0
    
    while x > 1
      @collector << "#{values[i]}, "
      i+=1
      x-=1
    end
    
    @collector << "#{values[i]}\n"
    
  end
  

  def finish
    $display.tell_user "Putting text output in to $collector. Access with $collector.csv"
    $collector.csv = @collector                       # wash out caps, spaces and slashes from tags
    $collector.output << $collector.csv               # for compatibility with other classes use of $collector
  end




end