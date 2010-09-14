class XML < Format
  attr_accessor :x


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

    @x = Builder::XmlMarkup.new(:target => @collector, :indent => 2)

    @x.instruct!

  end


#details (a comment about the report)


  def header(page_title = "Enter a title!", page_category = "Enter a category!") #pass you title and category in at this point...
    
    #puts together the whole header sections

    @x.comment!("header!")

    @x.header {
      self.title(page_title, page_category)
      self.date_section
    }

  end



  def title(page_title = "Enter a title!", page_category = "Enter a category")

    #prints title and category

    @x.title_section {
      @x.title("#{page_title}")
      @x.category("#{page_category}")
    }
  end

  def date_section

    #prints the dates

    @x.dates {
      @x.tag!("reporting", "#{$periods.start_date_reporting.strftime("%d/%m/%y")} - #{$periods.end_date_reporting.strftime("%d/%m/%y")}")
      @x.tag!("previous", "#{$periods.start_date_previous.strftime("%d/%m/%y")} - #{$periods.end_date_previous.strftime("%d/%m/%y")}")
      @x.tag!("baseline", "#{$periods.start_date_baseline.strftime("%d/%m/%y")} - #{$periods.end_date_baseline.strftime("%d/%m/%y")}")
    }

  end


  def main_graph(struct) #not refactored yet as it is done with google currently

    #makes the big three line graph

    #intended to make a lingraph with to flat averages
    #but could make a genuine three line graph if passed right

    #recieves ostruct containing .title (string)
    #                            .key (array of strings)
    #                            .data (an array of arrays - each array contains the data values)

    @x.linegraph{
      @x.title(struct.title)
      @x.data{
        i = 0
        struct.data.each do |data|

          @x.line("id"=>"#{struct.keys[i]}" ){
           data.each do |x|
              @x.value(x)
          end
          }
          i+=1
        end
      }
    }



  end

  def bar_series(struct)  #not refactored yet as it is done with google currently

    #prints a bargraph for a single series
    #expects an ostruct containing:

    # title, series (an array of values)

    @x.series_graph{
      @x.title(struct.title)
      @x.data{
        @x.series{
          struct.data.each do |data|
            data.each do |x|
              @x.value(x)
            end
          end
        }
      }
    }

    # <series_graph>
    #   <title>Traffic by hour</title>
    #   <data>
    #     <series>
    #       <value>585</value>
    #       <value>606</value>
    #       <value>674</value>
    #       <value>647</value>
    #     </series>
    #   </data>
    # </series_graph>

  end

  def table(struct)

    #prints a table with title and headings
    #expects a ostruct with :title, :header (an array of heading titles)
    #and :rows, an array of arrays of data.

    
    @x.tag!(struct.title){
      struct.rows.each do |row|
        i = 1
        n = row.length
        @x.tag!(struct.header[0]){
          @x.tag!("#{struct.header[0]}_name", row[0])
          while n > 1
            @x.tag!(struct.header[i], row[i])
            i+=1
            n-=1
          end
        }
      end
      }  
  end

  def block_full(struct)

    #prints a value with previous and baseline changes
    #expects an ostruct containing:

    #title, r, p_change, p_value, p_arrow, b_change, b_value, b_arrow

    @x.tag!(struct.title + "_section") {
      @x.reporting {
        @x.tag!(struct.title, struct.r)
      }
      @x.previous {
        @x.tag!(struct.title, struct.p_value)
        @x.tag!("#{struct.title}" + "_change", struct.p_change)
        @x.tag!("#{struct.title}" + "_arrow", struct.p_arrow)
      }
      @x.baseline {
        @x.tag!(struct.title, struct.b_value)
        @x.tag!("#{struct.title}" + "_change", struct.b_change)
        @x.tag!("#{struct.title}" + "_arrow", struct.b_arrow)
      }
    }

  end





  def comparison(array)  #not refactored yet as it is done with google currently

    #prints a bar divided between two proportions
    #expects an array with 4, and only 4, values

    if array.length != 3
      raise "Passed the XML.relative method an array that is the wrong length. It should be three."
    end

    @x.comparison_bar_graph {
      @x.title("#{array[0]}" + "/" + "#{array[1]}")
      @x.bar {
        @x.value("#{array[2]}")
        @x.value("#{array[3]}")
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

  def wash(xml)
    xml.gsub!(/((\<|\<\/)([a-z|\w|\s|_])+)\//, "\\1-")  # washing forward slashes from tags


    # $collector.xml = @collector.gsub!(/<\/?[^>]*>/){|match| match.downcase}     # washing caps from tags
    # $collector.xml = @collector.gsub!(/<\/?[^>]*>/){|match| match.downcase}     # washing caps from tags


    xml.gsub!(/<\/?[^>]*>/) do |match|
      match.downcase!
      match.sub!(" ", "_")
    end
        
   xml
  end


  def finish
    $display.tell_user "Putting xml output in to $collector. Access with $collector.xml"
    $collector.xml = self.wash(@collector)            # wash out caps, spaces and slashes from tags
    $collector.output << $collector.xml               # for compatibility with other classes use of $collector
  end




end