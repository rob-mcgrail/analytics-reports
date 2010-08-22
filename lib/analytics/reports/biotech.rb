class Biotech < Report
  attr_accessor :name, :collector
  
  #
  # most reports so far just use << append. this uses a custom array method "capture", which also prints to screen, 
  # useful for long slow reports
  #
  
  def initialize(name = "Biotech Detailed Report")
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
  
  def session_startup
    $profile = Profile.new
    $profile.string = "Biotech"
    $profile.garb = Garb::Profile.first('6076893') #needs to be changed
  end
  
  #----------segments
  
  # NZ -             1223813495
  # AUS -            930734061
  # USA -            759299489
  # No ANZUS -       829899234
  
  #2mins NZ          1132433923
  
  # Sciencelearn / Email Newsletter                       1673777621 #still use this
  
  
  # /about_biotech
  # 
  # /focus_stories
  # 
  # /focus_stories/biological_control_of_possums
  # /focus_stories/evolved_enzymes
  # /focus_stories/fish_oil_in_functional_food
  # /focus_stories/forensics
  # /focus_stories/future_foods
  # /focus_stories/honey_to_heal
  # /focus_stories/mining_milk
  # /focus_stories/nutrigenomics
  # /focus_stories/potato_plates
  # /focus_stories/robotic_milking
  # /focus_stories/taewa_maori_potatoes
  # /focus_stories/transgenic_cows
  # /focus_stories/wool_innovations
  # 
  # /themes
  # 
  # /themes/barcoding_life
  # /themes/biocontrol
  # /themes/bioethics
  # /themes/biotech_and_taonga
  # /themes/biotech_at_home
  # /themes/biotech_product_development
  # /themes/biotech_therapies
  # /themes/cell_biology_and_genetics
  # /themes/crime_scene_biotech
  # /themes/dna_lab
  # /themes/food_intolerance_and_allergies
  # /themes/future_farming
  # /themes/marvellous_milk
  # /themes/new_zealand_views_on_biotech
  # /themes/what_is_biotechnology
  # 
  # /news_and_events
  # 
  # /thinking_tools
  # 
  # /my_biotech
  
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
    # @collector << "Summary----------------------------------\n\n"
    # self.basic_summary
    # 
    # # country list here - needs its own method
    # 
    # $profile.segment = "1223813495"
    # $profile.segment_string = nil #reset
    # 
    # @collector <<  "\nNZ Summary----------------------------------\n\n"
    # self.single_visitor_type_segment
    # 
    # $profile.segment = "930734061"
    # $profile.segment_string = nil #reset
    # 
    # @collector <<  "\nAUS Summary----------------------------------\n\n"
    # self.single_visitor_type_segment
    # 
    # $profile.segment = "759299489"
    # $profile.segment_string = nil #reset
    # 
    # @collector <<  "\nUS Summary----------------------------------\n\n"
    # self.single_visitor_type_segment
    
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
    # nav.arbitrary_out("/Biotech/PrintLink", 10).each {|thing| @collector << thing}
    # 
    # $profile.segment = "1698453188"
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
    
    engagement_pages.ordered_by_time($periods.start_date_reporting, $periods.end_date_reporting, 10).each {|thing| @collector <<  thing}
    @collector <<  "\n\n"
    
    @collector <<  "By Views for #{$profile.segment_string}\n"
        
    engagement_pages.ordered_by_pageviews($periods.start_date_reporting, $periods.end_date_reporting, 10).each {|thing| @collector <<  thing}
    @collector <<  "\n\n"
    
    nav = Navigation.new
    @collector <<  "Navigation for #{$profile.segment_string}\n"
    
    nav.all_reporting($profile.segment_string, 15).each {|thing| @collector <<  thing} #path argument is the segment argument
    @collector <<  "\n\n"
  end
  
  def content_summaries
    
    $profile.segment_string = "/"
    
    self.content_info
    
    $profile.segment_string = "/focus_stories/"
    
    self.content_info
    
    $profile.segment_string = "/focus_stories/biological_control_of_possums"
    
    self.content_info

    
    $profile.segment_string = "/focus_stories/evolved_enzymes"
    
    self.content_info

    
    $profile.segment_string = "/focus_stories/fish_oil_in_functional_food"
    
    self.content_info

    
    $profile.segment_string = "/focus_stories/forensics"
    
    self.content_info

    
    $profile.segment_string = "/focus_stories/future_foods"
    
    self.content_info

    
    $profile.segment_string = "/focus_stories/honey_to_heal"
    
    self.content_info

    
    $profile.segment_string = "/focus_stories/mining_milk"
    
    self.content_info

    
    $profile.segment_string = "/focus_stories/nutrigenomics"
    
    self.content_info

    
    $profile.segment_string = "/focus_stories/potato_plates"
    
    self.content_info

    
    $profile.segment_string = "/focus_stories/robotic_milking"
    
    self.content_info

    
    $profile.segment_string = "/focus_stories/taewa_maori_potatoes"
    
    self.content_info

    
    $profile.segment_string = "/focus_stories/transgenic_cows"
    
    self.content_info

    
    $profile.segment_string = "/focus_stories/wool_innovations"
    
    self.content_info

    
    $profile.segment_string = "/themes/"
    
    self.content_info

    
    $profile.segment_string = "/themes/barcoding_life"
    
    self.content_info

    
    $profile.segment_string = "/themes/biocontrol"
    
    self.content_info

    
    $profile.segment_string = "/themes/bioethics"
    
    self.content_info

    
    $profile.segment_string = "/themes/biotech_and_taonga"
    
    
    self.content_info

    
    $profile.segment_string = "/themes/biotech_at_home"
    
    
    self.content_info

    
    $profile.segment_string = "/themes/biotech_product_development"
    
    self.content_info

    
    $profile.segment_string = "/themes/biotech_therapies"
    
    self.content_info

    
    $profile.segment_string = "/themes/cell_biology_and_genetics"
    
    self.content_info

    
    $profile.segment_string = "/themes/crime_scene_biotech"
    
    self.content_info

    
    $profile.segment_string = "/themes/dna_lab"
    
    
    self.content_info

    
    $profile.segment_string = "/themes/food_intolerance_and_allergies"
    
    
    self.content_info

    
    $profile.segment_string = "/themes/future_farming"
    
    self.content_info

    
    $profile.segment_string = "/themes/marvellous_milk"
    
    self.content_info
    
    $profile.segment_string = "/themes/new_zealand_views_on_biotech"
    
    self.content_info
    
    $profile.segment_string = "/themes/what_is_biotechnology"
    
    self.content_info
    
    $profile.segment_string = "/news_and_events"
    
    self.content_info
    
    $profile.segment_string = "/thinking_tools/"
    
    self.content_info
    
    $profile.segment_string = "/thinking_tools"
    
    self.content_info
    
    $profile.segment_string = "/my_biotech"
    
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
    
    engagement_pages.ordered_by_pageviews($periods.start_date_reporting, $periods.end_date_reporting, 14).each {|thing| @collector <<  thing}
    @collector <<  "\n\n"
    
    engagement_pages.ordered_by_time($periods.start_date_reporting, $periods.end_date_reporting, 14).each {|thing| @collector <<  thing}
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