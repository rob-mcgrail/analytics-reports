module GoogleChart
#  require 'gchart'
# => it hasn't worked for some of these, so I made them manually...

#
# A module for getting google chart api data data
#


#
# Note to self, the gem probably works fine, just had builder escaping issues
#

  def GoogleChart.bar_series(title, data, color = "BBCCED", size = "700x85", max = nil) #data is an array

    if max.nil? #checks if it was passed in
                                        # get the highest value to set the graph vertical range
      max = Num.round_up(data.max.to_i) # and round it up
    end

    data = self.to_param(data)
    title = self.to_param(title)

    src = ["http://chart.apis.google.com/chart",
          "?chxr=0,0,#{max}",
          "&chxs=0,676767,8.5,0,l,676767", #font size for x
          "&chxt=y",
          "&chbh=a,5",
          "&chs=#{size}",
          "&cht=bvg",
          "&chco=#{color}",
          "&chds=0,1037",
          "&chd=t:#{data}",
          "&chtt=#{title}",
          "&chts=676767,9" #font size for title
          ]

    src = self.to_request(src)
    src

  end
  
  def GoogleChart.comparison(title, value1, value_title1, value_title2)

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

