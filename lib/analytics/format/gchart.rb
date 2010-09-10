module GoogleChart
  require 'gchart'

  def GoogleChart.bar_series(title, data) #data is an array

    if !data[0].is_a? Integer
      data.each {|s| data << s.to_i}  #api expects integers
    end

    src = Gchart.bar(:title => title, :data => data)
    src
  end

#
# A module for getting google chart api data data
#


end

