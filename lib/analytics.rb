#internal

require 'rubygems'
require 'garb'
require 'gchart'
require 'active_support'
require 'action_pack'
require 'action_view'
require 'highline/import'

require 'builder'
require 'ostruct'
require 'net/http'
require 'fileutils'

# Monkeypatch to lengthen timeout in Net::HTTP

require 'net/http'

module Net
    class HTTP
        alias old_initialize initialize

        def initialize(*args)
            old_initialize(*args)
            @read_timeout = 60     # 3 minutes
        end
    end
end

PATH = File.expand_path(File.dirname(__FILE__))

#external
require PATH + "/analytics/array.rb"
require PATH + "/analytics/startup.rb"
require PATH + "/analytics/periods.rb"
require PATH + "/analytics/profile.rb"
require PATH + "/analytics/format.rb"
require PATH + "/analytics/report.rb"

#sub-farms
Dir[PATH + '/analytics/display/*.rb'].each {|file| require file }
Dir[PATH + '/analytics/helpers/*.rb'].each {|file| require file }
Dir[PATH + '/analytics/reports/*.rb'].each {|file| require file }
Dir[PATH + '/analytics/api/*.rb'].each {|file| require file }
