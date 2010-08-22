#parent
require File.expand_path(File.dirname(__FILE__) + "/reports/report.rb")

#children
require File.expand_path(File.dirname(__FILE__) + "/reports/prototype.rb")

#community usage stats grab
require File.expand_path(File.dirname(__FILE__) + "/reports/community_usage.rb")

#cmis stats grab
require File.expand_path(File.dirname(__FILE__) + "/reports/cmis.rb")

#big reports
require File.expand_path(File.dirname(__FILE__) + "/reports/sciencelearn.rb")
require File.expand_path(File.dirname(__FILE__) + "/reports/biotech.rb")

#a check for analytics
require File.expand_path(File.dirname(__FILE__) + "/reports/check.rb") #combined
require File.expand_path(File.dirname(__FILE__) + "/reports/tki_check.rb")
require File.expand_path(File.dirname(__FILE__) + "/reports/cwa_check.rb")
