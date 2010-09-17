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

    self.title
    self.date_section
    @collector << "\n"
    
  end
  
  def date_section
    @collector << "\n"
    
    @collector << "Reporting period: #{$periods.start_date_reporting.strftime("%d/%m/%y")} - #{$periods.end_date_reporting.strftime("%d/%m/%y")}"
    
    if $periods.start_date_previous != nil
      @collector << "Previous period: #{$periods.start_date_previous.strftime("%d/%m/%y")} - #{$periods.end_date_previous.strftime("%d/%m/%y")}"
    end
    
    if $periods.start_date_baseline != nil
      @collector << "Baseline period: #{$periods.start_date_baseline.strftime("%d/%m/%y")} - #{$periods.end_date_baseline.strftime("%d/%m/%y")}"
    end
    
  end



  def title(page_title = "Enter a title!", page_category = "Enter a category")

    @collector << "================="
    @collector << "#{page_title}"
    @collector << "#{page_category}"    
    @collector << "=================\n"

  end

  def single(name, value)

    @collector << "#{title}: #{value}"

  end



  def table(struct)

    #prints a table with title and headings
    #expects a ostruct with :title, :header (an array of heading titles)
    #and :rows, an array of arrays of data.

    @collector << "#{struct.title}\n"
    
    s = String.new
    
    struct.header.each do |head|
      s + "| " + head + "|"
    end
    
    @collector << s
    x = s.length
    
    s = String.new
    
    x.times { s + "-" }
    @collector << s
    
    
    s = String.new
      
    struct.rows.each do |row|
      s = String.new
      row.each do |value|
        s + "| " + value + "|"
      end
      @collector << s
    end
    @collector << "\n"
  end


  # def wash(txt)
  #   txt.gsub!(/((\<|\<\/)([a-z|\w|\s|_])+)\//, "\\1-")  # washing forward slashes from tags
  # 
  #   txt.gsub!("&amp;", "&")     # washing escapes!
  # 
  #   txt.gsub!(/<\/?[^>]*>/) do |match|
  #     match.downcase!
  #     match.gsub(" ", "_")
  #   end
  #       
  #  txt
  # end


  def finish
    $display.tell_user "Putting xml output in to $collector. Access with $collector.xml"
    $collector.txt = @collector                       # wash out caps, spaces and slashes from tags
    $collector.output << $collector.txt               # for compatibility with other classes use of $collector
  end




end