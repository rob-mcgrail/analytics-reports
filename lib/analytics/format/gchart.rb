module Charts

  def Charts.bar_series(title, data, color = "BBCCED", size = "700x85", max = nil)
    
    if max.nil?                         #checks if it was passed in
                                        # get the highest value to set the graph vertical range
      max = Num.round_up(data.max.to_i) # and round it up
    end
    
    Gchart.bar(:date => data, 
               :title => title, 
               :bar_colors => color,
               :size => size,
               :format => 'file',
               :filename => "#{$path}/zzzz.png",
               :max_value => max
               )
  end


  # def Charts.bar_series(title, data, color = "BBCCED", size = "700x85", max = nil) #data is an array
  # 
  #   if max.nil?                         #checks if it was passed in
  #                                       # get the highest value to set the graph vertical range
  #     max = Num.round_up(data.max.to_i) # and round it up
  #   end
  # 
  #   data = self.to_param(data)
  #   title = self.to_param(title)
  # 
  #   src = ["http://chart.apis.google.com/chart",
  #         "?chxr=0,0,#{max}",
  #         "&chxs=0,#{max},0,#{max},0,#{max}", #font size for x
  #         "&chxt=y",
  #         "&chbh=a,5",
  #         "&chs=#{size}",
  #         "&cht=bvg",
  #         "&chco=#{color}",
  #         "&chds=0,1037",
  #         "&chd=t:#{data}",
  #         "&chtt=#{title}",
  #         "&chts=676767,9" #font size for title
  #         ]
  # 
  #   src = self.to_request(src)
  #       
  #   src
  # 
  # end
  
  def Charts.comparison(title, value1, value_title1, value_title2)

    title = self.to_param(title)
    value_title1 = self.to_param(value_title1)
    value_title2 = self.to_param(value_title2)
    
    src = ["http://chart.apis.google.com/chart",
          "?chbh=a,2,3",
           "&chs=321x60",
           "&cht=bhs",
           "&chco=5A9D5A,224499",
           "&chd=t:#{value1}|100",        
           "&chdl=#{value_title1}|#{value_title2}",
           "&chp=0.017",
           "&chg=-1,43,0,0",
           "&chtt=#{title}",
           "&chts=676767,10.833"
          ]
    
    src = self.to_request(src)
    src
  end
  
  def Charts.large_linegraph(title, data1, data2, data3, data_title1, data_title2, data_title3, size = "700x200", max = nil)
    
    if max.nil?                     #checks if it was passed in
      
      z = [data1.max.to_i, data2.max.to_i, data3.max.to_i]
      
      max = Num.round_up(z.max.to_i) # and round it up
    end
    
    title = self.to_param(title)
    data1 = self.to_param(data1)
    data2 = self.to_param(data2)
    data3 = self.to_param(data3)
    data_title1 = self.to_param(data_title1)
    data_title2 = self.to_param(data_title2)
    data_title3 = self.to_param(data_title3)
  
  
    src =["http://chart.apis.google.com/chart",
          "?chxr=0,0,#{max}",
          "&chxt=y",
          "&chs=#{size}",
          "&cht=lc",
          "&chco=5A9D5A,224499,FF9900",
          "&chds=3.333,567856,-13.333,115,0,122.321",
          "&chd=t:#{data1}|#{data2}|#{data3}",            #make this flexible
          "&chdl=#{data_title1}|#{data_title2}|#{data_title3}",
          "&chg=-1,46,0,0",
          "&chls=1|1|1",
          "&chma=0,3|8",
          "&chtt=#{title}",
          "&chts=676767,11.833"
        ]
        
    src = self.to_request(src)
    src
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

