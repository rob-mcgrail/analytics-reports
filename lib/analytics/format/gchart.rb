module Charts
  require 'gchart'
  
  #
  #  This module shuffles away the gchart calls away from a report, to keep the report code clean
  #  It will be modified so that it can work for link and file output. Possibly just run both in tandem.
  #
  
  def Charts.bar_series(title, data,  color = "BBCCED", size = "710x85")
    
    if data[0].is_a? String
      a = Array.new
      data.each {|thing| a << thing.to_i}
      data = a
    end
    
    filename = "bar_series" + "#{DateTime.now.strftime("%d%m%M%S")}.png"
    
    x = data.length   #get the ammount of labels, less the ammount with names (so we can pack the middle with nothing)
    x-=2
        
    labels = ['00:00 NZT']    #first time
    x.times {labels << ""}    #pack the middle with nothing
    labels << '23:00 NZT'     #last time
    
    Gchart.bar(:data => data, 
              # :title => title,
              # :custom => '&chts=030000,11.5',
              
              :bar_colors => color,
              :size => size,
              :axis_with_labels => 'x',
              :axis_labels => [labels],
              :format => 'file',
              :filename => "#{$path}" + "/" + filename)
              
    filename
  end
  
  def Charts.labelled_series(title, data, keys, size = "300x200", color = "3072F3")
    
    if data[0].is_a? String
      a = Array.new
      data.each {|thing| a << thing.to_i}
      data = a
    end
    
    min = data.min
    max = data.max
    
    filename = "labelled_series" + "#{DateTime.now.strftime("%d%m%M%S")}.png"    
    
    Gchart.bar(:data => data,

               # :title => title,
               # :custom => '&chts=030000,11.5',
               
               :bar_colors => color,
               :orientation => 'horizontal',
               :size => size,
               :axis_with_labels => ['y', 'x'],
               :axis_labels => [[keys[4], keys[3], keys[2], keys[1], keys[0]], [0, max]],
               :format => 'file',
               :filename => "#{$path}" + "/" + filename
               )

    filename
  end
  
  def Charts.comparison(title, value1, value_title1, value_title2, size = "250x60")

    if value1.is_a? String
      s = value1.to_i
      value1 = s
    end
    
    filename = "comparison" + "#{DateTime.now.strftime("%d%m%M%S")}.png"
    
    Gchart.bar(:data => [[value1.to_i], [100]],

               # :title => title,
               # :custom => '&chts=030000,11.5',
               
               :bar_colors => ['5A9D5A','224499'],
               :size => size,
               :orientation => 'horizontal',
               :legend => [value_title1, value_title2],
               :format => 'file',
               :filename => "#{$path}" + "/" + filename
               )

      filename
  end
  
  def Charts.large_linegraph(title, data1, data2, data3, data_title1, data_title2, data_title3, size = "600x200")
    
    filename = "large_linegraph" + "#{DateTime.now.strftime("%d%m%M%S")}.png"
    
    a = [data1.max, data2.max, data3.max]
    max = a.max
    
    Gchart.line(:data => [data1, data2, data3],

               # :title => title,
               # :custom => '&chts=030000,11.5',

               :size => size,
               :legend => [data_title1, data_title2, data_title3],
               :custom => '&chdlp=t',
               :bar_colors => ['5A9D5A','224499', 'FF9900'],
               :axis_with_labels => ['y'],
               :axis_labels => [[0, "#{max}"]],
               :format => 'file',
               :filename => "#{$path}" + "/" + filename
               )
               
        
    filename
  end



end

