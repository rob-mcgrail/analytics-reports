module GoogleChart
  require 'gchart'

  def GoogleChart.bar_series(title, data, color = "BBCCED") #data is an array

    data = self.to_param(data)
    title = self.to_param(data)

    src = ["http://chart.apis.google.com/chart",
          "?chxr=0,0,900",
          "&chxs=0,676767,8.5,0,l,676767",
          "&chxt=y",
          "&chbh=a,5",
          "&chs=700x85",
          "&cht=bvg",
          "&chco=#{color}",
          "&chds=0,1037",
          "&chd=t:#{data}",
          "&chtt=#{title}",
          "&chts=676767,10.5"
          ]

    src = self.to_url(src)
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

  def self.to_url(array) #takes the array of parameters and adds together in to a string
                    #there's probably an array method already that does this'
    s = String.new
    array.each {|thing| s + thing}
    s
  end

#
# A module for getting google chart api data data
#


end

