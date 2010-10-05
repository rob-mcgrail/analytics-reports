class Community_Usage < Report
  
  def initialize(name = "Community Usage Stats")
    @name = name
    @collector = Array.new
    @now = DateTime.now
    @filepath = "output/#{@name}-#{$periods.start_date_reporting.strftime("%d%m%y")}-#{$periods.end_date_reporting.strftime("%d%m%y")}.csv"
    @text_file = File.new(@filepath, "w+")
    @profile_name = nil
  end
  
  def all
    $display.tell_user("I tend to take a long time...")
    
    self.header
    self.report("35630502", "Portal")
        
    self.report("14745867", "Ako Panuku")
    self.report("34260881", "Arts Online")
    self.report("7922426", "Asia Knowledge")
    self.report("10449435", "Assessment Online")
    self.report("9760563", "Digital technology Guidelines")
    self.report("10448201", "e-asTTle")
    self.report("12471470", "Education for Enterprise")
    self.report("9029662", "Education for Sustainability")
    self.report("16845949", "Educational Leaders")
    self.report("24247105", "e-Learning as Inquiry")
    self.report("14920696", "English Online")
    self.report("9371510", "EOTC/LEOTC")
    self.report("14920893", "ESOL Online")
    self.report("14962720", "He Kohinga Rauemi a Ipu Rangi (MLC)")
    self.report("22192627", "Hoatu Homai")
    self.report("22900702", "Home-School Partnerships")
    self.report("24329144", "ICT Helpdesk")
    self.report("19644726", "Key Competencies")
    self.report("26488837", "Kia Mau")
    self.report("10617005", "Ki te Auturoa (Instep)")
    self.report("9969846", "Language immersion Opportunities")
    self.report("8272347", "LEAP")
    self.report("24247423", "Learning Languages Guides")
    self.report("24247516", "Learning languages with ICTs")
    self.report("14920959", "Literacy Online")
    self.report("34229704", "Literacy Learning Progressions")
    self.report("26200548", "Ma te Pouaka (Maori Teachers Notes)")
    self.report("9226697", "NZ Curriculum")
    self.report("36101231", "Pasifika")
    self.report("9786892", "Professional Learning")
    self.report("8272137", "Promoting Healthy Lifestyles")
    self.report("23725351", "Putaiao")
    self.report("10354806", "RTLB")
    self.report("34006372", "Science Online")
    self.report("9760559", "Senior Secondary Guidelines")
    self.report("11978273", "Software for Learning")
    self.report("9555576", "Sounds and Words")
    self.report("7992968", "SSOL")
    self.report("9371496", "Success for Boys")
    self.report("23522664", "Taihape Area School")
    self.report("16617864", "Te Reo Maori")
    self.report("19752543", "Te tere Auraki")
    
    self.to_file
    self.timer
    self.path
  end
  
  def profile(profile, profile_name)
    @profile_name = profile_name
    
    $profile = Profile.new
    $profile.garb = Garb::Profile.first(profile)
    $profile.string = profile
  end
  
  def report(profile, profile_name)
    
    self.profile(profile, profile_name)
    
    @collector << @profile_name
    @collector << ", "
    
    visits = Visits.new
    @collector << visits.reporting
    @collector << ", "
    
    pageviews = PageViews.new
    @collector << pageviews.reporting
    @collector << ", "
    
    uniques = Uniques.new
    @collector << uniques.reporting
    @collector << ", "
    
    new_visits = NewVisits.new
    @collector << new_visits.reporting
    @collector << ", "
    
    returning_visits = visits.reporting - new_visits.reporting 
    @collector << returning_visits
    @collector << "\n"
    
  end
  
  def header
    @collector << "Name, Visits, PageViews, Uniques/Visitors, New Visits, Returning Visits\n"
  end
  
end