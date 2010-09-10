module GoogleChart

require 'gchart'

  def GoogleChart.bar_series(title, data) #data is an array

    src = Gchart.bar(:title => title, :data => data)
    src
  end

#
# A module for getting google chart api data data
#


end

