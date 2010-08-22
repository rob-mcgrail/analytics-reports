class Check < Report
  
  def dates
    $periods = Periods.new
    
    $periods.start_date_reporting = Date.today
    $periods.end_date_reporting = Date.today
    
    $periods.start_date_previous = Date.yesterday
    $periods.end_date_previous = Date.yesterday
  end
  
  def visit_check
    visits = Visits.new
    
    today = visits.reporting
    yesterday = visits.previous
    
    if today == 0
      if yesterday != 0
        $display.tell_user("#{@profile_name} had 0 visits today!\nThis is probably not really an issue...\n")
        self.soft_check(today, yesterday)
      end
    else
      self.soft_check(today, yesterday)
    end
    
    if yesterday == 0
      $display.alert_user("#{@profile_name} had 0 visits yesterday!\nCheck me...\n")
    end
    
  end
  
  def pageview_check
    pageviews = PageViews.new
    
    today = pageviews.reporting
    yesterday = pageviews.previous
    
    if today == 0
      $display.tell_user("#{@profile_name} had 0 pageviews today!\nThis is probably not really an issue...\n")
    end
    
    if yesterday == 0
      $display.alert_user("#{@profile_name} had 0 pageviews yesterday!\nCheck me...\n")
    end
  end
  
  def soft_check(today, yesterday)
    helper = Crunch.new
 
    if today == 0
      change = helper.percentage_change(yesterday, 1)
    else
      change = helper.percentage_change(yesterday, today)
    end

    change = change.to_i

    if change < -70
      if change < -90 
        $display.alert_user("#{@profile_name} visits decreased by more than 90% since yesterday (#{yesterday} => #{today})\nCheck me...\n")
      else
        $display.tell_user("#{@profile_name} visits decreased by #{change.abs}% since yesterday\nBut this is probably not really an issue...\n")
      end
    end
  end
  
end