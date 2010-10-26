module GVisualCharts
  require File.expand_path(File.dirname(__FILE__) + "../../../../plugins/winston-google_visualr/init.rb")
  
  def GVisualCharts.large_linegraph(title, data1, data2, data3, data_title1, data_title2, data_title3, width = 630, height = 200)
    
    @chart = GoogleVisualr::LineChart.new    

    @chart.add_column('string', 'Date' )
    @chart.add_column('number', data_title1)
    @chart.add_column('number', data_title2)
    @chart.add_column('number', data_title3)

    if data1.length != data2.length
      raise "You are sending GVisualCharts.large_linegraph arrays off differing lengths"
    end
    
    if data1.length != data3.length
      raise "You are sending GVisualCharts.large_linegraph arrays off differing lengths"
    end

    @chart.add_rows(data1.length)
    
    # @chart.set_value(0, 0, "#{$periods.end_date_reporting.strftime("%d/%m/%y")}")
    # @chart.set_value(data1.length - 1, 0, "#{$periods.end_date_reporting.strftime("%d/%m/%y")}")

    # i = 1
    # 
    # while i < (data1.length - 1)
    #   @chart.set_value(i, 0, "")
    #   i+=1
    # end

    i = 0
    
    while i < (data1.length)
      @chart.set_value(i, 1, data1[i])
      i+=1
    end

    i = 0
    
    while i < (data1.length)
      @chart.set_value(i, 2, data2[i])
      i+=1
    end
    
    i = 0
    
    while i < (data1.length)
      @chart.set_value(i, 3, data3[i])
      i+=1
    end

    @chart.width = width
    @chart.height = height
    @chart.legend = "bottom"
               
    chart = @chart.render("#{title}")
    
    puts chart
    
    chart
  end
  
end