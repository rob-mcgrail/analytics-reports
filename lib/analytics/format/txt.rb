class TXT < Format


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


#details (a comment about the report)


  def header(page_title = "Enter a title!", page_category = "Enter a category!") #pass you title and category in at this point...
    
    #puts together the whole header sections

    self.title(page_title, page_category)
    self.date_section
    @collector << "\n"
    
  end
  
  def date_section
    @collector << "\n"
    
    @collector << "Reporting period: #{$periods.start_date_reporting.strftime("%d/%m/%y")} - #{$periods.end_date_reporting.strftime("%d/%m/%y")}\n"
    
    if $periods.start_date_previous != nil
      @collector << "Previous period: #{$periods.start_date_previous.strftime("%d/%m/%y")} - #{$periods.end_date_previous.strftime("%d/%m/%y")}\n"
    end
    
    if $periods.start_date_baseline != nil
      @collector << "Baseline period: #{$periods.start_date_baseline.strftime("%d/%m/%y")} - #{$periods.end_date_baseline.strftime("%d/%m/%y")}\n"
    end
    
  end

  def x(string)   #this is provided for compatibility with other classes like xml, fop and html
    @collector << "\n" + string + "\n"
  end

  def title(page_title = "Enter a title!", page_category = "Enter a category")

    @collector << "================="
    @collector << "#{page_title}"
    @collector << "#{page_category}"    
    @collector << "=================\n"

  end

  def single(name, value)

    @collector << "#{name}: #{value}\n"

  end



  def table(struct)

    #prints a table with title and headings
    #expects a ostruct with :title, :header (an array of heading titles)
    #and :rows, an array of arrays of data.

    @collector << "#{struct.title}\n\n"
    
    s = String.new
    
    struct.header.each do |head|
      s << "  |  " + head
    end
    
    @collector << s  + "\n"
    
    x = s.length
    
    s = String.new
    
    x.times { s << "-" }
    @collector << s  + "\n"
    
    s = String.new
      
    struct.rows.each do |row|
      s = String.new
      row.each do |value|
        s << "  |  " + value
      end
      @collector << s  + "\n"
    end
    @collector << "\n"
  end


  def block_full(struct)

    #prints a value with previous and baseline changes
    #expects an ostruct containing:

    #title, r, p_change, p_value, p_arrow, b_change, b_value, b_arrow

    @collector << "\n   #{struct.title} | Main Graph\n\n"

    @collector << "#{struct.r}\n" 

    @collector << "   previous: #{struct.p_value} (#{struct.p_change}) [#{struct.p_arrow}]\n"
    @collector << "   baseline: #{struct.b_value} (#{struct.b_change}) [#{struct.b_arrow}]\n"
    
  end
  
  def comparison(array)

    #prints a bar divided between two proportions
    #expects an array with 3, and only 3, values

    if array.length != 3
      raise "Passed the TXT.relative method an array that is the wrong length. It should be three."
    end

    #make changes to the values so one is 100, one is itself

    @collector << "#{array[0]}" + " / " + "#{array[1]}"
    
    @collector << "     #{array[2]}"

  end
  
  def labelled_series(struct)
    
    #
    # gets chart class to return a png of the depth or length of visit style bar graph
    #
    # expects a :title, :data (array), :keys (array of strings)
    #
  
    if struct.data[0].length != struct.keys.length
      raise "Passed the TXT.labelled_series a different ammount of values and keys..."
    end
    
    values = struct.data[0]
    x = struct.keys.length
    i = 0
    
    @collector << "#{struct.title}\n"
    
    while x > 0
      @collector << "   #{struct.keys[i]}:    #{values[i]}\n"
    
      i+=1
      x-=1
    end
    
  end

  def main_graph(struct) #not refactored yet as it is done with google currently

    #makes the big three line graph

    #intended to make a lingraph with to flat averages
    #but could make a genuine three line graph if passed right

    #recieves ostruct containing .title (string)
    #                            .key (array of strings)
    #                            .data (an array of arrays - each array contains the data values)

    @collector << "\n#{struct.title} | Main Graph\n\n"
    
    @collector << "     #{struct.title} | previous ave: #{struct.data[1].first}\n\n"
    
    @collector << "     #{struct.title} | baseline ave: #{struct.data[2].first}\n\n"

    @collector << "     #{struct.title} | reporting:\n\n"

    struct.data[0].each {|i| @collector << "#{i}\n"}

  end
  
  def bar_series(struct)  #not refactored yet as it is done with google currently

    #prints a bargraph for a single series
    #expects an ostruct containing:

    # title, series (an array of values)

    @collector << "#{struct.title} | Bar series\n\n"

    struct.data[0].each {|i| @collector << "#{i}\n"}

  end  


  def finish
    $display.tell_user "Putting text output in to $collector. Access with $collector.txt"
    $collector.txt = @collector                       # wash out caps, spaces and slashes from tags
    $collector.output << $collector.txt               # for compatibility with other classes use of $collector
  end




end