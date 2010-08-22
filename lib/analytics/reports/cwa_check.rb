class CWA_Check < Check
  
  def initialize(name = "CWA analytics tracking check")
    @name = name
    @now = DateTime.now
    @profile_name = nil
    self.dates
  end
  
  def all
    $display.ask_user("\nI tend to take a long time...\n") # not really... but in combination it does...

    # sites coevered by Technical contract (Jill) SLA

    self.report("15639222", "Circa")
    self.report("19921286", "Banking Ombudsman")
    self.report("18984301", "TEC (Literacy and Numeracy)")
    self.report("14608700", "WickED")

    # for the Hubs gang

    self.report("6076893", "Biotech hub")
    self.report("6092288", "Science hub")
    
    self.timer
  end
  
  def profile(profile, profile_name)
    @profile_name = profile_name
    
    $profile = Profile.new
    $profile.garb = Garb::Profile.first(profile)
    $profile.string = profile
  end
  
  def report(profile, profile_name)
    self.profile(profile, profile_name)
    
    $display.ask_user("Checking #{@profile_name}...\n")
    
    self.visit_check
    self.pageview_check
  end
  
  def timer
    time_elapsed = "\n\nI took #{((DateTime.now - @now) * 24 * 60 * 60).to_i} seconds.\n"
    $display.ask_user(time_elapsed)
  end
  
end