class Fop < XML
  include GoogleChart

  def bar_series(struct)
        #gets a url for a bargraph from the google charts api
        #expects an ostruct containing:

        # title, series (an array of values)

    src = GoogleChart.bar_series(struct.title, struct.data[0])

    @x.series_graph{
      @x.external_graphic(:src => src )
    }
  end
  
  def comparison(array)

    #prints a bar divided between two proportions
    #expects an array with 3, and only 3, values

    if array.length != 3
      raise "Passed the Fop.relative method an array that is the wrong length. It should be three."
    end

      #make changes to the values so one is 100, one is itself

    src = GoogleChart.comparison("#{array[0]}" + " / " + "#{array[1]}", array[2], array[0], array[1])
    
    @x.comparison_bar{
      @x.external_graphic(:src => src)
    }
  end
  
  
  def bar_series(struct)

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
  
  

  def finish
    $display.tell_user "Putting fop-ready xml output in to $collector. Access with $collector.fop"
    $collector.fop = @collector.gsub('&amp;', '&') #washing out the escape sequences...
  end
  
  

end

