class Report
  attr_accessor :name, :collector
  
  def initialize(name = "Prototype")
    @name = name
    @collector = Array.new
    @now = DateTime.now
    @filepath = "output/#{@name}-#{@now.strftime("%d%m%y")}.txt"
    @text_file = File.new(@filepath,  "w+") 
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
  
  def to_screen
    @collector.each {|thing| $display.print(thing)}
  end
  
  def to_file(n = nil)
    if n.nil?
      @collector.each {|thing| @text_file << thing.to_s}
    else
      @collector.each {|thing| @text_file << thing.to_s+"\n"}
    end
  end
  
  def timer
    time_elapsed = "\n\nI took #{((DateTime.now - @now) * 24 * 60 * 60).to_i} seconds.\n"
    @text_file << time_elapsed
    $display.tell_user(time_elapsed)
  end
  
  def path
    $display.tell_user("The things I did are in: #{@filepath}")
  end
  
end