module Scruff
  require 'scruffy'
  
  # def Scruff.large_linegraph(title, data1, data2, data3, data_title1, data_title2, data_title3, size = "600x200")
  #   
  #   filename = "large_linegraph" + "#{DateTime.now.strftime("%d%m%M%S")}.svg"
  #   
  #   a = [data1.max, data2.max, data3.max]
  #   max = a.max
  #   
  #   Gchart.line(:data => [data1, data2, data3],
  # 
  #              # :title => title,
  #              # :custom => '&chts=030000,11.5',
  # 
  #              :size => size,
  #              :legend => [data_title1, data_title2, data_title3],
  #              :custom => '&chdlp=t',
  #              :bar_colors => ['5A9D5A','224499', 'FF9900'],
  #              :axis_with_labels => ['y'],
  #              :axis_labels => [[0, "#{max}"]],
  #              :format => 'file',
  #              :filename => "#{$path}" + "/" + filename
  #              )
  #              
  #       
  #   filename
  # end
  
  
  def Scruff.large_linegraph(title, data1, data2, data3, data_title1, data_title2, data_title3, size = "600x200")
    
    filename = "large_linegraph" + "#{DateTime.now.strftime("%d%m%M%S")}.svg"
    
    graph = Scruffy::Graph.new(:title => "#{title}")
    graph.renderer = Scruffy::Renderers::Standard.new
        
    graph.add(:line, data_title1, data1)
    graph.add(:line, data_title2, data2)
    graph.add(:line, data_title3, data3)

               
    graph.render(:to => "#{$path}" + "/" + filename)
    
    filename
  end
  
end