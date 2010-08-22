class Sciencelearn < Report
  attr_accessor :name, :collector
  
  #
  # most reports so far just use << append. this uses a custom array method "capture", which also prints to screen, 
  # useful for long slow reports
  #
  
  def initialize(name = "Sciencelearn Detailed Report")
    @name = name
    @collector = Array.new
    @now = DateTime.now
    @filepath = "output/#{@name}-#{@now.strftime("%d%m")}.txt"
    @text_file = File.new(@filepath,  "w+") 
  end
  
  def header
    @collector <<  "\nReport run #{@now}" + "\n"
    @collector <<  "\nProfile: #{$profile.string}" + "\n"
    self.dates.each {|thing| @collector <<  thing}
    @collector <<  "\n"
  end
  
  #this is just for testing / building
  #seperate out afterwards
  
  #although this will be altered throughout this report
  #in order to change the segment.
  
  def session_startup
    $profile = Profile.new
    $profile.string = "Sceincelearn"
    $profile.garb = Garb::Profile.first('6092288')
  end
  
  #----------segments
  
  # NZ -             1223813495
  # AUS -            930734061
  # USA -            759299489
  # No ANZUS -       829899234
  
  #>2mins NZ         1132433923
  
  # Sciencelearn / Email Newsletter                       1673777621
  
  
  # /Contexts                    
  # 
  # /Contexts/Earthquakes        
  # /Contexts/Enviro-imprints    
  # /Contexts/Fire               
  # /Contexts/Future-Fuels       
  # /Contexts/H2O-On-the-Go      
  # /Contexts/Hidden-Taonga      
  # /Contexts/Icy-Ecosystems     
  # /Contexts/Just-Elemental
  # /Contexts/Life-in-the-Sea    
  # /Contexts/Nanoscience        
  # /Contexts/Saving-Reptiles    
  # /Contexts/See-through-Body   
  # /Contexts/Space-Revealed     
  # /Contexts/Sporting-Edge      
  # /Contexts/Volcanoes          
  # /Contexts/You-Me-and-UV
  # 
  # /Science-Stories
  # /Science-Stories/Butterflies
  # /Science-Stories/Celebrating-Science
  # /Science-Stories/Microorganisms
  # /Science-Stories/Our-Heritage-Scientists
  # /Science-Stories/Research-Voyage-to-Antarctica
  # /Science-Stories/Resource-Management
  # /Science-Stories/Strange-Liquids
  # 
  # /News-Events
  # 
  # /Thinking-Tools
  # 
  # /My-Sci  
  
  # stories
  
  # newsletter                      1673777621
  
  # New visits                      -2
  # New NZ                          2138653054
  # New Aus                         750482683
  # New US                          284734655
  
  
  # Returning visits                -3
  # Returning NZ                    868866970
  # Returning Aus                   633087029
  # Returning US                    1488059557
  
  # >2mins
  
  # >2mins NZ
  
  #search                           -6
   
  def main
    @collector << "Summary----------------------------------\n\n"
    self.basic_summary
    
    # country list here - needs its own method
    
    $profile.segment = "1223813495"
    $profile.segment_string = nil #reset
    
    @collector <<  "\nNZ Summary----------------------------------\n\n"
    self.single_visitor_type_segment
    
    $profile.segment = "930734061"
    $profile.segment_string = nil #reset
    
    @collector <<  "\nAUS Summary----------------------------------\n\n"
    self.single_visitor_type_segment
    
    $profile.segment = "759299489"
    $profile.segment_string = nil #reset
    
    @collector <<  "\nUS Summary----------------------------------\n\n"
    self.single_visitor_type_segment
    # 
    $profile.segment = "1132433923"
    $profile.segment_string = nil #reset
    
    @collector <<  "\nNZ > 2 minutes Summary----------------------------------\n\n"
    self.single_visitor_type_segment
    
    # $profile.segment = "-6"
    # $profile.segment_string = nil #reset
    # 
    # @collector << "Search----------------------------------\n\n"
    # self.basic_summary
    # 
    # #this segment doesn't work - it just returns EVERYTHING??
    # 
    # # $profile.segment = "829899234"
    # # $profile.segment_string = nil #reset
    # # 
    # # @collector <<  "\nEverything else Summary----------------------------------\n\n"
    # # self.single_visitor_type_segment
    # 
    # $profile.segment = "-2"
    # $profile.segment_string = nil #reset
    # 
    # @collector <<  "\nNew----------------------------------\n\n"
    # self.new_returning_visitor_segment
    # 
    # $profile.segment = "2138653054"
    # $profile.segment_string = nil #reset
    # 
    # @collector <<  "\nNew New Zealand----------------------------------\n\n"
    # self.new_returning_visitor_segment
    # 
    # $profile.segment = "-3"
    # $profile.segment_string = nil #reset
    # 
    # @collector <<  "\nReturning----------------------------------\n\n"
    # self.new_returning_visitor_segment
    # 
    # $profile.segment = "868866970"
    # $profile.segment_string = nil #reset
    # 
    # @collector <<  "\nReturning New Zealand----------------------------------\n\n"
    # self.new_returning_visitor_segment
    # 
    # $profile.segment = "1673777621"
    # $profile.segment_string = nil #reset
    # 
    # @collector <<  "\nNewsLetter----------------------------------\n\n"
    # self.special_source
    # 
    # $profile.segment = nil  #reset
    # $profile.segment_string = nil #reset
    # 
    # ## PrintLink info just dumped in...
    # 
    # @collector <<  "\nMost Printed----------------------------------\n\n"
    # nav = Navigation.new
    # nav.arbitrary_out("/Sciencelearn/PrintLink", 10).each {|thing| @collector << thing}
    # 
    # $profile.segment = "371923089"
    # 
    # depth = Depth.new
    # depth.basic_five.each {|thing| @collector << thing}
    # @collector << "\n\n"
    # 
    # length = Length.new
    # length.big_site = nil
    # length.basic_five_reporting.each {|thing| @collector << thing}
    # @collector << "\n\n"
    # 
    # nz_versus_international = CountryVisits.new("New Zealand")
    # nz_versus_international.three_comparison_against_baseline.each {|thing| @collector << thing}
    # @collector << "\n\n"
    #     
    # $profile.segment = nil  #reset
    # $profile.segment_string = nil #reset
    # 
    # self.content_summaries
    # 
    # $profile.segment = nil  #reset
    # $profile.segment_string = nil #reset
    # 
    # $profile.segment = "1223813495"
    # @collector << "New Zealand Only Content Summaries"
    # 
    # self.content_summaries
    # 
    # $profile.segment = nil  #reset
    # $profile.segment_string = nil #reset
  end
  
  def basic_summary
    
    visits = Visits.new
    visits.main_graph.each {|thing| @collector <<  thing}
    @collector <<  "\n\n"
        
    visits.three_with_changes.each {|thing| @collector <<  thing}
    @collector <<  "\n\n"
     
    uniques = Uniques.new
    uniques.three_monthly_averages.each {|thing| @collector <<  thing}
    @collector <<  "\n\n"
    
    bounces = BounceRate.new
    bounces.three_with_changes.each {|thing| @collector <<  thing}
    @collector <<  "\n\n"
    
    times = Times.new
    times.three_with_changes_as_averages.each {|thing| @collector <<  thing}
    @collector <<  "\n\n"
    
    pageviews = PageViews.new
    pageviews.three_with_changes_per_visit.each {|thing| @collector << thing}
    @collector << "\n"
    
    new_returning = NewVisits.new
    @collector <<  new_returning.reporting_only
    @collector <<  "\n\n"
    
    websources_list = WebSources.new
    websources_list.processed_reporting_bounce_and_time(7)
    websources_list.reporting_list.each {|thing| @collector <<  thing}
    @collector <<  "\n\n"
    
    countries_list = CountrySource.new
    countries_list.processed_reporting(7)
    countries_list.reporting_list.each {|thing| @collector <<  thing}
    
    visits.hours_graph.each {|thing| @collector <<  thing}
    
  end
  
  def content_info
    views = PageViews.new
    @collector << "#{$profile.segment_string}\n"
    reporting = views.arbitrary_page($profile.segment_string)
    
    previous = views.arbitrary_page($profile.segment_string, $periods.start_date_previous, $periods.end_date_previous)
    @collector << "Reporting\n"

    @collector << reporting
    @collector << "Previous\n"
    
    @collector << previous
    @collector << "Change\n\n"
    
    @collector << views.percentage_change(previous, reporting)
    
    @collector << "\n\n"
    
    engagement_pages = Content.new #????
    
    engagement_pages.calculate_limit($periods.start_date_reporting, $periods.end_date_reporting)
    @collector <<  "Content pageviews limit is #{engagement_pages.limit}\n"
    
    @collector <<  "By Time for #{$profile.segment_string}\n"
    
    engagement_pages.ordered_by_time($periods.start_date_reporting, $periods.end_date_reporting, 5).each {|thing| @collector <<  thing}
    @collector <<  "\n\n"
    
    @collector <<  "By Views for #{$profile.segment_string}\n"
        
    engagement_pages.ordered_by_pageviews($periods.start_date_reporting, $periods.end_date_reporting, 5).each {|thing| @collector <<  thing}
    @collector <<  "\n\n"
    
    nav = Navigation.new
    @collector <<  "Navigation for #{$profile.segment_string}\n"
    
    nav.all_reporting($profile.segment_string, 7).each {|thing| @collector <<  thing} #path argument is the segment argument
    @collector <<  "\n\n"
  end
  
  def content_summaries
    
    $profile.segment_string = "/"
    
    self.content_info
    
    $profile.segment_string = "/Contexts"
    
    self.content_info
    
    $profile.segment_string = "/Contexts/Earthquakes"
    
    self.content_info

    
    $profile.segment_string = "/Contexts/Enviro-imprints"
    
    self.content_info

    
    $profile.segment_string = "/Contexts/Fire"
    
    self.content_info

    
    $profile.segment_string = "/Contexts/Future-Fuels"
    
    self.content_info

    
    $profile.segment_string = "/Contexts/H2O-On-the-Go"
    
    self.content_info

    
    $profile.segment_string = "/Contexts/Hidden-Taonga"
    
    self.content_info

    
    $profile.segment_string = "/Contexts/Icy-Ecosystems"
    
    self.content_info

    
    $profile.segment_string = "/Contexts/Just-Elemental"
    
    self.content_info

    
    $profile.segment_string = "/Contexts/Life-in-the-Sea"
    
    self.content_info

    
    $profile.segment_string = "/Contexts/Nanoscience"
    
    self.content_info

    
    $profile.segment_string = "/Contexts/Saving-Reptiles"
    
    self.content_info

    
    $profile.segment_string = "/Contexts/See-through-Body"
    
    self.content_info

    
    $profile.segment_string = "/Contexts/Space-Revealed"
    
    self.content_info

    
    $profile.segment_string = "/Contexts/Sporting-Edge"
    
    self.content_info

    
    $profile.segment_string = "/Contexts/Volcanoes"
    
    self.content_info

    
    $profile.segment_string = "/Contexts/You-Me-and-UV"
    
    self.content_info

    
    $profile.segment_string = "/Science-Stories"
    
    self.content_info

    
    $profile.segment_string = "/Science-Stories/Butterflies"
    
    
    self.content_info

    
    $profile.segment_string = "/Science-Stories/Celebrating-Science"
    
    
    self.content_info

    
    $profile.segment_string = "/Science-Stories/Microorganisms"
    
    self.content_info

    
    $profile.segment_string = "/Science-Stories/Our-Heritage-Scientists"
    
    self.content_info

    
    $profile.segment_string = "/Science-Stories/Research-Voyage-to-Antarctica"
    
    self.content_info

    
    $profile.segment_string = "/Science-Stories/Resource-Management"
    
    self.content_info

    
    $profile.segment_string = "/Science-Stories/Strange-Liquids"
    
    
    self.content_info

    
    $profile.segment_string = "/News-Events"
    
    
    self.content_info

    
    $profile.segment_string = "/Thinking-Tools"
    
    self.content_info

    
    $profile.segment_string = "/My-Sci"
    
    self.content_info

  end
  
  def single_visitor_type_segment
    
    visits = Visits.new
    visits.main_graph.each {|thing| @collector <<  thing}
    @collector <<  "\n\n"
        
    visits.three_with_changes.each {|thing| @collector <<  thing}
    @collector <<  "\n\n"
     
    uniques = Uniques.new
    uniques.three_monthly_averages.each {|thing| @collector <<  thing}
    @collector <<  "\n\n"
    
    bounces = BounceRate.new
    bounces.three_with_changes.each {|thing| @collector <<  thing}
    @collector <<  "\n\n"
    
    times = Times.new
    times.three_with_changes_as_averages.each {|thing| @collector <<  thing}
    @collector <<  "\n\n"
    
    pageviews = PageViews.new
    pageviews.three_with_changes_per_visit.each {|thing| @collector << thing}
    @collector << "\n"
    
    new_returning = NewVisits.new
    @collector <<  new_returning.reporting_only
    @collector <<  "\n\n"
    
    websources_list = WebSources.new
    websources_list.processed_reporting_bounce_and_time(5)
    websources_list.reporting_list.each {|thing| @collector <<  thing}
    @collector <<  "\n\n"
    
    engagement_pages = Content.new
    engagement_pages.calculate_limit($periods.start_date_reporting, $periods.end_date_reporting)
    @collector <<  "Content pageviews limit is #{engagement_pages.limit}\n"
    
    engagement_pages.ordered_by_pageviews($periods.start_date_reporting, $periods.end_date_reporting, 7).each {|thing| @collector <<  thing}
    @collector <<  "\n\n"
    
    engagement_pages.ordered_by_time($periods.start_date_reporting, $periods.end_date_reporting, 7).each {|thing| @collector <<  thing}
    @collector <<  "\n\n"
    
    visits.hours_graph.each {|thing| @collector <<  thing}
    
  end
  
  def new_returning_visitor_segment
    
    visits = Visits.new
    visits.main_graph.each {|thing| @collector <<  thing}
    @collector <<  "\n\n"
        
    visits.three_with_changes.each {|thing| @collector <<  thing}
    @collector <<  "\n\n"
     
    # uniques = Uniques.new
    # uniques.three_monthly_averages.each {|thing| @collector <<  thing}
    # @collector <<  "\n\n"
    
    bounces = BounceRate.new
    bounces.three_with_changes.each {|thing| @collector <<  thing}
    @collector <<  "\n\n"
    
    websources_list = WebSources.new
    websources_list.processed_reporting_bounce_and_time(5)
    websources_list.reporting_list.each {|thing| @collector <<  thing}
    @collector <<  "\n\n"
    
    engagement_pages = Content.new
    engagement_pages.calculate_limit($periods.start_date_reporting, $periods.end_date_reporting)
    @collector <<  "Content pageviews limit is #{engagement_pages.limit}\n"
    
    engagement_pages.ordered_by_time($periods.start_date_reporting, $periods.end_date_reporting, 7).each {|thing| @collector <<  thing}
    @collector <<  "\n\n"
        
    engagement_pages.ordered_by_pageviews($periods.start_date_reporting, $periods.end_date_reporting, 7).each {|thing| @collector <<  thing}
    @collector <<  "\n\n"
    
    depth = Depth.new
    depth.basic_five.each {|thing| @collector <<  thing}
    @collector <<  "\n\n"
    
    length = Length.new
    length.basic_five_reporting.each {|thing| @collector <<  thing}
    @collector <<  "\n\n"
    
  end
  
  def special_source
    visits = Visits.new
    # visits.main_graph.each {|thing| @collector <<  thing}
    # @collector <<  "\n\n" #was causing a failure...
    visits.reporting_by_day.each {|thing| @collector <<  thing}
        
    visits.three_with_changes.each {|thing| @collector <<  thing}
    @collector <<  "\n\n"
     
    uniques = Uniques.new
    uniques.three_monthly_averages.each {|thing| @collector <<  thing}
    @collector <<  "\n\n"
    
    bounces = BounceRate.new
    bounces.three_with_changes.each {|thing| @collector <<  thing}
    @collector <<  "\n\n"
    
    pageviews = PageViews.new
    pageviews.three_with_changes_per_visit.each {|thing| @collector <<  thing}
    @collector <<  "\n\n"
    
    times = Times.new
    times.three_with_changes_as_averages.each {|thing| @collector <<  thing}
    @collector <<  "\n\n"
  end
  
  def end_game
    # self.to_screen
    self.to_file("n")
    self.timer
    self.path
  end
  
end