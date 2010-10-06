class Community_Usage < Report
  
  def initialize(name = "Community Usage Stats")
    @name = name
    @now = DateTime.now
    
    @dir = "community_usage"
    @path = File.expand_path(File.dirname(__FILE__) + "/../../../output/#{@dir}")
    FileUtils.mkdir_p @path
    @file = File.new(@path + "/#{@name.gsub(" ", "-").downcase}-#{@now.strftime("%d%m")}.csv",  "w+")
    $path = @path #export path variable for formatting classes that need it
  end
  
  def all
    $display.tell_user("I tend to take a long time...")
    
    self.header
    self.values("35630502", "Portal")
        
    self.values("14745867", "Ako Panuku")
    self.values("34260881", "Arts Online")
    self.values("7922426", "Asia Knowledge")
    self.values("10449435", "Assessment Online")
    self.values("9760563", "Digital technology Guidelines")
    self.values("10448201", "e-asTTle")
    self.values("12471470", "Education for Enterprise")
    self.values("9029662", "Education for Sustainability")
    self.values("16845949", "Educational Leaders")
    self.values("24247105", "e-Learning as Inquiry")
    self.values("14920696", "English Online")
    self.values("9371510", "EOTC/LEOTC")
    self.values("14920893", "ESOL Online")
    self.values("14962720", "He Kohinga Rauemi a Ipu Rangi (MLC)")
    self.values("22192627", "Hoatu Homai")
    self.values("22900702", "Home-School Partnerships")
    self.values("24329144", "ICT Helpdesk")
    self.values("19644726", "Key Competencies")
    self.values("26488837", "Kia Mau")
    self.values("10617005", "Ki te Auturoa (Instep)")
    self.values("9969846", "Language immersion Opportunities")
    self.values("8272347", "LEAP")
    self.values("24247423", "Learning Languages Guides")
    self.values("24247516", "Learning languages with ICTs")
    self.values("14920959", "Literacy Online")
    self.values("34229704", "Literacy Learning Progressions")
    self.values("26200548", "Ma te Pouaka (Maori Teachers Notes)")
    self.values("9226697", "NZ Curriculum")
    self.values("36101231", "Pasifika")
    self.values("9786892", "Professional Learning")
    self.values("8272137", "Promoting Healthy Lifestyles")
    self.values("23725351", "Putaiao")
    self.values("10354806", "RTLB")
    self.values("34006372", "Science Online")
    self.values("9760559", "Senior Secondary Guidelines")
    self.values("11978273", "Software for Learning")
    self.values("9555576", "Sounds and Words")
    self.values("7992968", "SSOL")
    self.values("9371496", "Success for Boys")
    self.values("23522664", "Taihape Area School")
    self.values("16617864", "Te Reo Maori")
    self.values("19752543", "Te tere Auraki")
    
    $format.finish

  end
  
  def profile(profile, profile_name)
    @profile_name = profile_name
    
    $profile = Profile.new
    $profile.garb = Garb::Profile.first(profile)
    $profile.string = profile
  end
  
  def values(profile, profile_name)
    
    self.profile(profile, profile_name)
    
    visits = Visits.new
    pageviews = PageViews.new
    uniques = Uniques.new
    new_visits = NewVisits.new
    
    returning_visits = visits.reporting - new_visits.reporting 
    
    $format.values [@profile_name, visits.reporting, pageviews.reporting, uniques.reporting, new_visits.reporting, returning_visits]
    
    
  end
  
  def header
    $format.header ["Name", "Visits", "PageViews", "Uniques/Visitors", "New Visits", "Returning Visits"]
  end
  
end