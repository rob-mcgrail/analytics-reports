class Report
  attr_accessor :name
  
  def initialize(name = "Prototype")
    @name = name
    @now = DateTime.now
    
    @dir = "output/#{DateTime.now.strftime("%d%m%M%S")}"
    @file = File.new($path + "/#{@name}-#{@now.strftime("%d%m")}.txt",  "w+")
  end
  
  def start
    self.mkdir
    self.dates
    self.to_s
  end
  
  def mkdir
    FileUtils.mkdir_p "#{@dir}"
  end
  
  def inspect
    puts "#{@name} times:\n"
    puts "Reporting period starts #{$periods.reporting_start}\n"
    puts "Reporting period ends #{$periods.reporting_end}\n"
    puts "Previous period starts #{$periods.previous_start}\n"
    puts "Previous period ends #{$periods.previous_end}\n"
    puts "Baseline period starts #{$periods.baseline_start}\n"
    puts "Baseline period ends #{$periods.baseline_end}\n"
  end
  
  def to_s
    "A report called #{@name}"
  end
  
  def dates
    dates = ["Reporting period starts #{$periods.reporting_start}\n",
             "Reporting period ends #{$periods.reporting_end}\n",
             "Previous period starts #{$periods.previous_start}\n",
             "Previous period ends #{$periods.previous_end}\n",
             "Baseline period starts #{$periods.baseline_start}\n",
             "Baseline period ends #{$periods.baseline_end}\n"]
  end
  
  def to_file
    $format.collector.each {|line| @file << line}
  end
  
  def to_screen
    $format.collector.each {|line| $display << line}
  end
  
  def timer
    time_elapsed = "\n\nI took #{((DateTime.now - @now) * 24 * 60 * 60).to_i} seconds.\n"
    @text_file << time_elapsed
    $display.tell_user(time_elapsed)
  end
  
  def path
    $display.tell_user("The things I did are in: #{$path}")
  end
  
  def endgame
    self.to_file
    self.to_screen
    self.timer
    self.tell_user
  end
  
end