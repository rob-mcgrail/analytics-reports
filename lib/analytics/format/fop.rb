class fop < XML

  def bar_series(struct)
        #gets a url for a bargraph from the google charts api
        #expects an ostruct containing:

        # title, series (an array of values)
    puts "this is the bar series method from fop"

  end

  def finish
    $display.tell_user "Putting fop-ready xml output in to $collector. Access with $collector.fop"
    $collector.fop = @collector
  end

end

