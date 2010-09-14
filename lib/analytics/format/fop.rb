class Fop < XML
  include Charts
  
  def initialize
    if !defined? $collector
      $display << "The collector is not defined. I am instantiating it now..."
      $collector = OpenStruct.new #this will be initialized by whichever object gets there first
      $collector.output = String.new #this is so there is always an easy compatible print method in report classes
      
    end
    
    @collector = String.new #this is the local collector
                            #to 'go global', run self.finish

    @x = Builder::XmlMarkup.new(:target => @collector, :indent => 2)

    @x.instruct!
    
    

    #set values for arrows

    @green_up = "<external_graphic>up_green.png</external_graphic>"
    @green_down = "<external_graphic>down_green.png</external_graphic>"
    @red_up = "<external_graphic>up_red.png</external_graphic>"
    @red_down = "<external_graphic>down_red.png</external_graphic>"
    @grey_up = "<external_graphic>up_grey.png</external_graphic>"
    @grey_down = "<external_graphic>down_grey.png</external_graphic>"
    @equals = "<external_graphic>equals.png</external_graphic>"
    
  end

  def bar_series(struct)
        #gets a url for a bargraph from the google charts api
        #expects an ostruct containing:

        # title, series (an array of values)

    src = Charts.bar_series(struct.title, struct.data[0])

    @x.series_graph{
      @x.external_graphic(src)
    }
  end
  
  def comparison(array)

    #prints a bar divided between two proportions
    #expects an array with 3, and only 3, values

    if array.length != 3
      raise "Passed the Fop.relative method an array that is the wrong length. It should be three."
    end

    #make changes to the values so one is 100, one is itself

    src = Charts.comparison("#{array[0]}" + " / " + "#{array[1]}", array[2], array[0], array[1])
    
    @x.comparison_bar{
      @x.external_graphic(src)
    }
  end
  

  def main_graph(struct)

    #makes the big three line graph

    #intended to make a lingraph with to flat averages
    #but could make a genuine three line graph if passed right
    
    src = Charts.large_linegraph(struct.title, struct.data[0], struct.data[1], struct.data[2], struct.keys[0], struct.keys[1], struct.keys[2])
    
    @x.main_graph{
      @x.external_graphic(src)
    }
  end
  
  def finish
    self.copy_assets
    $display.tell_user "Putting xml output in to $collector. Access with $collector.fop"
    $collector.fop = self.wash(@collector)            # wash out caps, spaces and slashes from tags
    $collector.output << $collector.fop               # for compatibility with other classes use of $collector
  end
  
  def copy_assets
    FileUtils.cp(File.expand_path(File.dirname(__FILE__) + "/../../../assets/arrows/up_green.png"), $path + "/")
  end
  
end

