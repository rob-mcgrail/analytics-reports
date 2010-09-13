class Startup
# Interface contains all the initial terminal commands - getting dates, passwords, etc
# to add - do you want to use a predefined report?
# to add - please select your desired report items
# todo - make this not unix terminal dependent... by passing view stuff off to Display maybe

  def initialized
    if !defined? $collector
      $periods = Periods.new  #ecapsulates dates
      $display << "Startup is reating $periods object."
  end


  def start_single_profile_session
    #main basic startup routine - gets credentials and dates, starts session

    self.authenticate_session
    self.select_profile
    self.get_dates_with_options #_no_options = assumes you'll use comparison date ranges;
                                #_with_options = comparison ranges are optional
  end

  def authenticate_session
    self.get_credentials
    begin
      Garb::Session.login(@username, @password)
    rescue Garb::AuthenticationRequest::AuthError
      $display.alert_user "Bad password! Try again\n\n"
      self.authenticate_session
    end
  end

  def get_credentials
    $display.ask_user('Username')
    @username = gets.chomp
    @password = $display.get_private('Password')
  end

  def select_profile
    $display.ask_user('Enter the profile you want stats for (ie 20425901)Type')
    chosen_profile = gets.chomp

    $profile = Profile.new
    $profile.string = chosen_profile
    $profile.garb = Garb::Profile.first(chosen_profile)
  end

  def select_reporting_period
    $display.ask_user('Enter the end date (inclusive) for the reporting period (dd/mm/yyyy)')
    begin
      $periods.end_date_reporting = Date.strptime(gets.chomp, "%d/%m/%Y")
    rescue ArgumentError
      $display.alert_user "Bad date! Try again\n\n"
      self.select_reporting_period
    end

    $display.ask_user('How many months long is the reporting period?')
    $periods.reporting_number_of_months = gets.chomp.to_i
    $periods.start_date_reporting = $periods.end_date_reporting.months_ago($periods.reporting_number_of_months)
                                    #generates @start_date based on $periods.end_date and ammount of months

    $display.tell_user("Reporting period is #{$periods.start_date_reporting} through #{$periods.end_date_reporting}, inclusive.\n")
  end

  def select_reporting_period_arbitrary
    $display.ask_user('Enter the start date (inclusive) for the reporting period (dd/mm/yyyy)')
    begin
      $periods.end_date_reporting = Date.strptime(gets.chomp, "%d/%m/%Y")
    rescue ArgumentError
      $display.alert_user "Bad date! Try again\n\n"
      self.select_reporting_period_arbitrary
    end

    $display.ask_user('Enter the end date (inclusive) for the reporting period (dd/mm/yyyy)')
    $periods.end_date_reporting = Date.strptime(gets.chomp, "%d/%m/%Y")

    $display.tell_user("Reporting period is #{$periods.start_date_reporting} through #{$periods.end_date_reporting}, inclusive.\n")
  end

  def arbitrary_periods
    self.select_reporting_period_arbitrary

    $display.ask_user('Do you want to compare against the prior period? (Recommended)')
    response = gets.chomp
    if response =~ /N|n|No|no/
      $display.tell_user("Expect errors, or bad data, if your report includes methods that expect a previous period\n")
    else
      $display.ask_user('How many months was that? :/ yeah...')
      $periods.reporting_number_of_months = gets.chomp.to_i
      self.generate_previous_period
    end

    self.select_baseline_period
  end

  def generate_previous_period
    #generates dates for previous_period automatically based on reporting_preiod

    decreased_start_date = $periods.start_date_reporting-(1)
    decreased_end_date = $periods.end_date_reporting-(1)

    $periods.start_date_previous = decreased_start_date.months_ago($periods.reporting_number_of_months)
    $periods.end_date_previous = decreased_end_date.months_ago($periods.reporting_number_of_months)

    $display.tell_user("Previous comparison period is #{$periods.start_date_previous} through #{$periods.end_date_previous}, inclusive.\n")
  end

  def select_baseline_period
    $display.ask_user('Enter the end date - (dd/mm/yyyy) - or hit x to place baseline up to beginning of reporting period (and including previous comparison period)')
    reply = gets.chomp

    if reply =~ /x|X/
      $periods.end_date_baseline = $periods.start_date_reporting-(1) #automatically makes $periods.end_date automatically based on reporting dates
    else
      begin
        $periods.end_date_baseline = Date.strptime(reply, "%d/%m/%Y") #or takes user entered date
      rescue ArgumentError
        $display.alert_user "Bad date! Try again\n\n"
        self.select_baseline_period
      end
    end
    $display.ask_user('How many months?')
    $periods.baseline_number_of_months = gets.chomp.to_i
    $periods.start_date_baseline = $periods.end_date_baseline.months_ago($periods.baseline_number_of_months) #generates @start_date based on $periods.end_date and ammount of months

    $display.tell_user("Baseline period is #{$periods.start_date_baseline} through #{$periods.end_date_baseline}, inclusive.\n")
  end

  def get_dates_no_options
    #basic date collection

    self.select_reporting_period
    self.select_baseline_period
    self.generate_previous_period
  end

  def get_dates_with_options
    #conditional date collection - allows for no previous or reporting period

    self.select_reporting_period
    $display.ask_user('Do you want to compare against the prior period? (Recommended)')
    response = gets.chomp
    if response =~ /N|n|No|no/
      $display.tell_user("Expect errors, or bad data, if your report includes methods that expect a previous period\n")
    else
      self.generate_previous_period
    end

    $display.ask_user('Do you want a baseline comparison period? (Recommended)')
    response = gets.chomp
    if response =~ /N|n|No|no/
      $display.tell_user("Expect errors, or bad data, if your report includes methods that expect a baseline\n")
    else
      self.select_baseline_period
    end
  end

end

