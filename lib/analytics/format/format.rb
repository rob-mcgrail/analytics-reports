class Format
  attr_reader :green_up, :green_down, :red_up, :red_down, :grey_up, :grey_down, :equals

  def initialize

    #make sure there is a collector object, if not, make one

    if !defined? $collector
      $display << "The collector is not defined. I am instantiating it now..."
      $collector = OpenStruct.new
    end

    @collector = String.new #this is the local collector
                            #to 'go global', run self.finish

    #set values for arrows

    @green_up = "green_up"
    @green_down = "green_down"
    @red_up = "red_up"
    @red_down = "red_down"
    @grey_up = "grey_up"
    @grey_down = "grey_down"
    @equals = "equals"
  end

  def finish
    $display.tell_user "Putting output in to $collector. Access with $collector.output"
    $collector.output = @collector
  end

end

