#internal

require 'rubygems'
require 'garb'
require 'builder'
require 'highline/import'
require 'active_support'
require 'action_pack'
require 'action_view'
require 'ostruct'
require 'net/http'
require 'gchart'
require 'fileutils'

# Monkey patch:

require 'net/http'

# Lengthen timeout in Net::HTTP
module Net
    class HTTP
        alias old_initialize initialize

        def initialize(*args)
            old_initialize(*args)
            @read_timeout = 60     # 3 minutes
        end
    end
end


#external
require File.expand_path(File.dirname(__FILE__) + "/analytics/array.rb")
require File.expand_path(File.dirname(__FILE__) + "/analytics/startup.rb")
require File.expand_path(File.dirname(__FILE__) + "/analytics/periods.rb")
require File.expand_path(File.dirname(__FILE__) + "/analytics/profile.rb")


#sub-farms
require File.expand_path(File.dirname(__FILE__) + "/analytics/helpers.rb")

require File.expand_path(File.dirname(__FILE__) + "/analytics/display.rb")

require File.expand_path(File.dirname(__FILE__) + "/analytics/api.rb")

require File.expand_path(File.dirname(__FILE__) + "/analytics/reports.rb")

require File.expand_path(File.dirname(__FILE__) + "/analytics/format.rb")



