require File.expand_path(File.dirname(__FILE__) + "/TESTINFO.rb")

#see rob for account details to make these tests work.
#otherwise you need to organise your own, and rewrite the test values

class Biotech_session

  def initialize(print = nil)
    #preset credentials and dates for testing
  
    Garb::Session.login($TEST_ACCOUNT, $TEST_PASSWORD)
    
    $profile = Profile.new
    $profile.garb = Garb::Profile.first('6076893')
    $profile.string = "6076893"

    
    # $profile = Garb::Profile.first('UA-10148230-1')

    $periods = Periods.new
    
    $periods.start_date_reporting = Date.new(y=2010,m=1,d=9)
    $periods.end_date_reporting = Date.new(y=2010,m=3,d=9)
    $periods.start_date_previous = Date.new(y=2009,m=11,d=8)
    $periods.end_date_previous = Date.new(y=2010,m=1,d=8)
    $periods.start_date_baseline = Date.new(y=2009,m=7,d=8)
    $periods.end_date_baseline = Date.new(y=2010,m=1,d=8)
    $periods.reporting_number_of_months = 2
    $periods.baseline_number_of_months = 6

    if print
      say(%{\n<%= color('Testing session definitions:', RED)%>\n\n})
      puts "Profile: " + $profile.string + "\n"
      $periods.inspect
      puts "\n"
    end
  end
  
end

#see rob for account details to make these tests work.
#otherwise you need to organise your own, and rewrite the test values

class Biotech_segment

  def initialize(print = nil)
    #preset credentials and dates for testing
  
    Garb::Session.login($TEST_ACCOUNT, $TEST_PASSWORD)
    
    $profile = Profile.new
    $profile.garb = Garb::Profile.first('6076893')
    $profile.string = "6076893"
    $profile.segment = "1429193700"

    $periods = Periods.new
    
    $periods.start_date_reporting = Date.new(y=2010,m=2,d=28)
    $periods.end_date_reporting = Date.new(y=2010,m=3,d=31)
    $periods.start_date_previous = Date.new(y=2010,m=1,d=27)
    $periods.end_date_previous = Date.new(y=2010,m=2,d=28)
    $periods.start_date_baseline = Date.new(y=2009,m=2,d=27)
    $periods.end_date_baseline = Date.new(y=2010,m=2,d=27)
    $periods.reporting_number_of_months = 1
    $periods.baseline_number_of_months = 12

    if print
      say(%{\n<%= color('Testing session definitions:', RED)%>\n\n})
      puts "Profile: " + $profile.string + "\n"
      $periods.inspect
      puts "\n"
    end
  end
  
end