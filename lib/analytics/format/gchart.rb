module Charts
  require 'gchart'
  
  def Charts.bar_series(title, data,  color = "BBCCED", size = "700x85")
    
    if data[0].is_a? String
      a = Array.new
      data.each {|thing| a << thing.to_i}
      data = a
    end
    
    filename = "bar_series" + "#{DateTime.now.strftime("%d%m%M%S")}.png"
    
    Gchart.bar(:data => data, 
              :title => title, 
              :bar_colors => color,
              :size => size,
              :axis_with_labels => 'x',
              :axis_labels => ['00:00 NZT','23:00 NZT'],
              :format => 'file',
              :filename => "#{$path}" + "/" + filename)
              
    filename
  end

  
  def Charts.comparison(title, value1, value_title1, value_title2, size = "320x60")

    if value1.is_a? String
      s = value1.to_i
      value1 = s
    end
    
    filename = "comparison" + "#{DateTime.now.strftime("%d%m%M%S")}.png"
    
    # src = ["http://chart.apis.google.com/chart",
    #       "?chbh=a,2,3",
    #        "&chs=321x60",
    #        "&cht=bhs",
    #        "&chco=5A9D5A,224499",
    #        "&chd=t:#{value1}|100",        
    #        "&chdl=#{value_title1}|#{value_title2}",
    #        "&chp=0.017",
    #        "&chg=-1,43,0,0",
    #        "&chtt=#{title}",
    #        "&chts=676767,10.833"
    #       ]
    
      Gchart.bar(:data => [[value1.to_i], [100]],
                 :title => title, 
                 :bar_colors => ['5A9D5A','224499'],
                 :size => size,
                 :orientation => 'horizontal',
                 :legend => [value_title1, value_title2],
                 :format => 'file',
                 :filename => "#{$path}" + "/" + filename
                 )

      filename
  end
  
  def Charts.large_linegraph(title, data1, data2, data3, data_title1, data_title2, data_title3, size = "700x200")
    
    # if max.nil?                     #checks if it was passed in
    #   
    #   z = [data1.max.to_i, data2.max.to_i, data3.max.to_i]
    #   
    #   max = Num.round_up(z.max.to_i) # and round it up
    # end
    
    Gchart.bar(:data => [data1, data2, data3],
               :title => title,
               :size => size,
               :legend => [data_title1, data_title2, data_title3],
               :bar_colors => ['5A9D5A','224499', 'FF9900'],
               :axis_with_labels => ['y'],
               :format => 'file',
               :filename => "#{$path}" + "/" + filename
               )

  
  
    # src =["http://chart.apis.google.com/chart",
    #       "?chxr=0,0,#{max}",
    #       "&chxt=y",
    #       "&chs=#{size}",
    #       "&cht=lc",
    #       "&chco=5A9D5A,224499,FF9900",
    #       "&chds=3.333,567856,-13.333,115,0,122.321",
    #       "&chd=t:#{data1}|#{data2}|#{data3}",            #make this flexible
    #       "&chdl=#{data_title1}|#{data_title2}|#{data_title3}",
    #       "&chg=-1,46,0,0",
    #       "&chls=1|1|1",
    #       "&chma=0,3|8",
    #       "&chtt=#{title}",
    #       "&chts=676767,11.833"
    #     ]
        
        filename
  end

  def self.to_param(thing) #can take a string (title, adds +) or array (adds together with commas)

    string = String.new

    if thing.is_a? Array  #format array of values for parameter
      thing.each do |x|
        string << "#{x},"
      end
      string.chop!
    end

    if thing.is_a? String #format titles for parameter
      string = thing.gsub(" ", "+")
      string = thing.gsub("/", "%2F")
    end
    string
  end

  def self.to_request(array) #takes the array of parameters and adds together in to a string
                              #there's probably an array method already that does this'
    s = String.new
    array.each {|thing| s << thing}
    s
  end



end

