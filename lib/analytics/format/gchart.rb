module GoogleChart
#  require 'gchart'
# => it hasn't worked for some of these, so I made them manually...

#
# A module for getting google chart api data data
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
    puts src
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

