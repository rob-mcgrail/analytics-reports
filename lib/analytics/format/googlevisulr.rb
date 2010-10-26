module GVisualCharts
  require File.expand_path(File.dirname(__FILE__) + "../../../../plugins/winston-google_visualr/init.rb")
  
  def GVisualCharts.large_linegraph(title, data1, data2, data3, dates, data_title1, data_title2, data_title3, width = 630, height = 200)
    
    @chart = GoogleVisualr::LineChart.new    

    @chart.add_column('string', 'Date' )
    @chart.add_column('number', data_title1)
    @chart.add_column('number', data_title2)
    @chart.add_column('number', data_title3)

    if data1.length != (data2.length + data3.length)/2
      raise "You are sending GVisualCharts.large_linegraph arrays off differing lengths"
    end

    @chart.add_rows(data1.length)

    i = 0
    while i < (dates.length)
      @chart.set_value(i, 0, dates[i].strftime("%e/%m"))
      i+=1
    end    

    i = 0; x = 1
    [data1, data2, data3].each do |array|
      i = 0
      while i < (array.length)
        @chart.set_value(i, x, array[i])
        i+=1
      end
      x+=1
    end

    @chart.width = width
    @chart.height = height
    @chart.legend = "bottom"
    @chart.title = title
    @chart.titleFontSize = 13
    @chart.lineSize = 2
    @chart.pointSize = 1
    @chart.axisFontSize = 11
                       
    unique = "#{title}-#{rand(100000)}"
    
    js = @chart.render(unique)
    
    $format.x.div("id"=>"#{unique}"){
      $format.collector << js
    }

  end
 
  def GVisualCharts.bar_series(title, data, width = 730, height = 90)
  
      if data[0].is_a? String
        a = Array.new
        data.each {|thing| a << thing.to_i}
        data = a
      end
      
      @chart = GoogleVisualr::ColumnChart.new
      
      @chart.add_column('string', 'Hour')
      @chart.add_column('number', 'Visits')
  
      @chart.add_rows(data.length)
      
      i = 0
      while i < (data.length)
        @chart.set_value(i, 1, data[i])
        i+=1
      end

  
      @chart.width = width
      @chart.height = height
      @chart.legend = "none"
      @chart.title = title
      @chart.titleFontSize = 13
      @chart.axisFontSize = 11
      

      unique = "#{title}-#{rand(100000)}"

      js = @chart.render(unique)

      $format.x.div("id"=>"#{unique}"){
        $format.collector << js
      }

  end
    
end