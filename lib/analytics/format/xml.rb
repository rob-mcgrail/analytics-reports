class XML < Format
  attr_accessor :x
  
  def initialize
    if !defined? $collector
      $display.tell_user("The collector is not defined. I am instantiating it now...")
      $collector = String.new
    end
    
    #set values for arrows
    
    @green_up = "green_up.png"
    @green_down = "green_down.png"
    @red_up = "red_up.png"
    @red_down = "red_down.png"
    @grey_up = "grey_up.png"
    @grey_down = "grey_down.png"
    @equals = "equals.png"
    
    @x = Builder::XmlMarkup.new(:target => $collector, :indent => 2)
    
    @x.instruct!
    
  end


#details (a comment about the report)

#page   ----> maybe not...

  def header(page_title = "Enter a title!", page_category = "Enter a category!") #pass you title and category in at this point...

    #puts together the whole header sections

    @x.comment!("header!")

    @x.header {
      self.title(page_title, page_category)
      @x.logo("cwa_logo.png")
      self.date_section
    }
    
    # <!-- header! -->
    # <header>
    #   <title_section>
    #     <category>Enter a category!</category>
    #     <title>Enter a title!</title>
    #   </title_section>
    #   <logo>cwa_logo.png</logo>
    #   <date_block>
    #     <date_range>Reporting period 09/01/10 - 09/03/10</date_range>
    #     <date_range>Reporting period 08/11/09 - 08/01/10</date_range>
    #     <date_range>Reporting period 08/07/09 - 08/01/10</date_range>
    #   </date_block>
    # </header>
  end


#footer

  def title(page_title = "Enter a title!", page_category = "Enter a category")
    
    #prints title and category
    
    @x.title_section {
      @x.category("#{page_category}")
      @x.title("#{page_title}")
    }
  end

  def date_section
    
    #prints the dates
    
    @x.date_block {
      @x.date_range("Reporting period #{$periods.start_date_reporting.strftime("%d/%m/%y")} - #{$periods.end_date_reporting.strftime("%d/%m/%y")}")
      @x.date_range("Reporting period #{$periods.start_date_previous.strftime("%d/%m/%y")} - #{$periods.end_date_previous.strftime("%d/%m/%y")}")
      @x.date_range("Reporting period #{$periods.start_date_baseline.strftime("%d/%m/%y")} - #{$periods.end_date_baseline.strftime("%d/%m/%y")}")
    }
    
  end
    

#line_graph

#series

  # def block_wrapper(array) #can something like this work?
  #   
  #   @x.data_block {
  #     array.each {|thing| thing}
  #   }
  #   
  # end

  def block_full(struct)  #you need to apply me to every class!!!
    
    #prints a value with previous and baseline changes
    #expects an ostruct containing:
    
    #title, r, p_change, p_value, p_arrow, b_change, b_value, b_arrow
   
    @x.block_item {
      @x.main {
        @x.value_title(struct.title)
        @x.value(struct.r)
      }
      @x.previous {
        @x.change(struct.p_change)
        @x.arrow(struct.p_arrow)
        @x.value(struct.p_value)
      }
      @x.baseline {
        @x.change(struct.b_change)
        @x.arrow(struct.b_arrow)
        @x.value(struct.b_value)      
      }
    }
    
    # <block_full>
    #  <main>
    #   <value_title>Visits</value_title>
    #   <value>18456</value>
    #  </main>
    #  <previous>
    #   <change>28%</change>
    #   <arrow>green_up.png</arrow>
    #   <value>14422</value>
    #  </previous>
    #  <baseline>
    #   <change>31%</change>
    #   <arrow>green_up.png</arrow>
    #   <value>14072.0</value>
    #  </baseline>
    # </block_full>
  end



#block_single

#block_comparison

#table

  def relative(array)
    
    #prints a bar divided between two proportions
    #expects an array with 2, and only 2, values
    
    if array.length != 3
      raise "Passed the XML.relative method an array that is the wrong length. It should be three."
    end
    
    @x.comparison_bar_graph {
      @x.title("#{array[0]}")
      @x.bar {
        @x.value("#{array[1]}")
        @x.value("#{array[2]}")
      }
    }
    
    # <comparison_bar_graph>
    #   <title>New / Returning</title>
    #   <bar>
    #     <value>83</value>
    #     <value>17</value>
    #   </bar>
    # </comparison_bar_graph>
  end

#bar





  
end