class Biotech < Report
  attr_accessor :name
  
  def initialize(name = "Biotech deatiled report")
    @name = name
    @now = DateTime.now
    
    @dir = "output/#{DateTime.now.strftime("%d%m%M%S")}"
    @file = File.new($path + "/#{@name}-#{@now.strftime("%d%m")}.txt",  "w+")
  end

  
end