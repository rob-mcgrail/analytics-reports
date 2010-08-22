class CMIS < Report
  
  def initialize(name = "CMIS")
    @name = name
    @collector = Array.new
    @now = DateTime.now
    @filepath = "output/#{@name}-#{@now.strftime("%d%m%y")}.txt"
    @text_file = File.new(@filepath, "w+")
    @profile_name = nil
    @month = $periods.start_date_reporting.strftime("%B")
  end
  
  def all
    $display.tell_user("I tend to take a long time...")
    
    @collector << "My range is #{$periods.start_date_reporting} => #{$periods.end_date_reporting} (inclusive)"
    @collector << "\n"
    
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
    self.report("10617005", "Ki te Aut\305\253roa (Instep)")
    self.report("9969846", "Language immersion Opportunities")
    self.report("8272347", "LEAP")
    self.report("24247423", "Learning Languages Guides")
    self.report("24247516", "Learning languages with ICTs")
    self.report("14920959", "Literacy Online")
    self.report("26200548", "Ma te Pouaka (M\304\201ori Teachers Notes)")
    self.report("9226697", "NZ Curriculum")
    self.report("9786892", "Professional Learning")
    self.report("8272137", "Promoting Healthy Lifestyles")
    self.report("23725351", "P\305\253taiao")
    self.report("10354806", "RTLB")
    self.report("9760559", "Senior Secondary Guidelines")
    self.report("11978273", "Software for Learning")
    self.report("9555576", "Sounds and Words")
    self.report("7992968", "SSOL")
    self.report("9371496", "Success for Boys")
    self.report("23522664", "Taihape Area School")
    self.report("16617864", "Te Reo M\304\201ori")
    self.report("19752543", "Te tere Auraki")
    
    self.to_screen
    self.to_file("n")
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
    @collector << "\n"
    
    uniques = Uniques.new
    @collector << "visitors / uniques"
    @collector << uniques.reporting.to_s + " (#{@month})"
    
    @collector << "\n"
    
  end
  
end