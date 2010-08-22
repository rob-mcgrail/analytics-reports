class Prototype < Report
  
  def initialize(name = "Prototype")
    @name = name
    @collector = Array.new
    @now = DateTime.now
    @filepath = "output/#{@name}-#{@now.strftime("%d%m%y")}-#{$profile.string}.txt"
    @text_file = File.new(@filepath,  "w+") 
  end
  
  def all
    puts "     ...I am working..."
    self.header
    self.page_one
    self.page_two
    self.page_three
    self.to_screen
    self.to_file("n")
    self.timer
    self.path
  end
  
  def header
    @collector << "\nReport run #{@now}" + "\n"
    @collector << "\nProfile: #{$profile.string}" + "\n"
    self.dates.each {|thing| @collector << thing}
    @collector << "\n"
   end
  
  def page_one
     @collector << self.page_heading(1)
     @collector << "\n"
     
     visits = Visits.new
     visits.main_graph.each {|thing| @collector << thing}
     @collector << "\n"
     
     visits.three_with_changes.each {|thing| @collector << thing}
     @collector << "\n"
     
     uniques = Uniques.new
     uniques.three_monthly_averages.each {|thing| @collector << thing}
     @collector << "\n"
     
     bounces = BounceRate.new
     bounces.three_with_changes.each {|thing| @collector << thing}
     @collector << "\n"
     
     nz_versus_international = CountryVisits.new("New Zealand")
     nz_versus_international.three_comparison_against_baseline.each {|thing| @collector << thing}
     @collector << "\n"
     
     new_returning = NewVisits.new
     new_returning.three_new_versus_returning_against_baseline.each {|thing| @collector << thing}
     @collector << "\n"
     
     websources_list = WebSources.new
     websources_list.processed_reporting_bounce_and_time(7)
     websources_list.reporting_list.each {|thing| @collector << thing}
     @collector << "\n"
  end
  
  def page_two
    @collector << self.page_heading(2)
    @collector << "\n"
    
    times = Times.new
    times.three_with_changes_as_averages.each {|thing| @collector << thing}
    @collector << "\n"
    
    pageviews = PageViews.new
    pageviews.three_with_changes_per_visit.each {|thing| @collector << thing}
    @collector << "\n"
    
    home_bounces = BounceRate.new
    home_bounces.three_with_changes_by_path("/")
    home_bounces.all_results.each {|thing| @collector << thing}
    @collector << "\n"
    
    loyalty = Loyalty.new
    loyalty.basic_five
    loyalty.all_results.each {|thing| @collector << thing}
    @collector << "\n"
    
    depth = Depth.new
    depth.basic_five
    depth.all_results.each {|thing| @collector << thing}
    @collector << "\n"
    

    
  end
  
  def page_three
    
  end
  
  def page_heading(x)
    "===========--------Page #{x}---------============\n"
  end
  
end