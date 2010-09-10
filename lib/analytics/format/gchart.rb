module GoogleChart

require 'gchart'

  def bar_series(struct)
    a = struct.data[0]
    src = Gchart.bar(:title => struct.title, :data => a)
    src
  end

#
# A module for getting google chart api data data
#


end

