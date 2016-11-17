#!/usr/bin/env ruby

require_relative 'dcl'
require_relative 'stack'

ENV['debug'] = '1'

usage = 'ruby run.rb (stacks) [arguments]'

begin
puts case ARGV.shift
     when 'stacks'       then Stack.new(ARGV).run
     when 'reset'        then DCL.reset_cache
     when 'namespace'    then DCL.update_namespace(ARGV[0])
     else raise usage
     end
rescue => e
  cmd = 'tell application "Alfred 3" to run trigger "dockercloud error" in workflow "com.creators.dockercloud" with argument "' + e.to_s.gsub("'", '') + '"'
  `osascript -e '#{cmd}'`
end
