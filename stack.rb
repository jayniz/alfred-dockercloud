require 'uri'

require_relative 'alfred_output'

class Stack
  def initialize(argv)
    @argv = argv
  end

  def run
    case @argv.first
    when 'refresh' then request(false)
    when 'search'  then search(@argv[1])
    else usage
    end
  end

  def usage
    puts "Unknown arguments #{@argv.join(' ')}"
    puts 'Usage: ./run.rb stacks (refresh|search) [searchterm]'
  end

  def all
    @all ||= request['objects'].map do |stack|
      {
        name: stack['name'],
        uuid: stack['uuid'],
        url: resource_uri_to_browser_url(stack['resource_uri'])
      }
    end
  end

  def resource_uri_to_browser_url(uri)
    uri.gsub('/api/app/v1/', 'https://cloud.docker.com/app/')
  end

  def suggest_refresh(name)
    AlfredOutput.build do |a|
      a.item(
        uid: 'refresh',
        title: "Can't find #{name} #{namespace}",
        subtitle: 'Hit ↩ to refresh from docker cloud and search again'
      )
    end
  end

  def namespace
    @namespace ||= if DCL.namespace.to_s.strip != ''
                    "in namespace #{DCL.namespace}"
                   else
                     ''
                   end
  end

  def search(name)
    regexp = Regexp.new ".*#{name.chars.join('.*')}.*"
    stacks = all.select do |stack|
      stack[:name].to_s =~ regexp
    end.sort_by do |stack|
      stack[:name].length
    end

    return suggest_refresh(name) if stacks.empty?

    AlfredOutput.build do |a|
      stacks.each do |stack|
        a.item(
          uid: stack[:uuid],
          title: stack[:name],
          arg: stack[:url],
          subtitle: 'Stack ' + namespace
        )
      end
    end
  end

  def request(cached = true)
    DCL.request('stack/?limit=1000', cached)
  end
end
