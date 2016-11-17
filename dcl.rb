require 'base64'
require 'fileutils'
require 'json'
require 'net/http'
require 'uri'

def log(msg)
  return unless ENV['DEBUG']
  puts msg
end

class DCL
  def self.namespace
    return unless File.exist?('.namespace')
    namespace = open('.namespace').read.chomp.strip
    namespace == '' ? nil : namespace
  end

  def self.update_namespace(namespace)
    ns = namespace.to_s.strip.gsub('"', '')
    File.open('.namespace', 'w') { |f| f.puts ns }

    if ns != ''
      cmd = "tell application \"Alfred 3\" to run trigger \"organization updated\" in workflow \"com.jayniz.dockercloud\" with argument \"Using namespace #{ns}\""
    else
      cmd = 'tell application "Alfred 3" to run trigger "organization updated" in workflow "com.jayniz.dockercloud" with argument "Using default namespace"'
    end
    puts cmd
    `osascript -e '#{cmd}'`
  end

  def self.config
    config_path = "#{ENV['HOME']}/.docker/config.json"
    @config ||= JSON.parse(open(config_path).read)
  rescue => e
    puts e
    puts "Please 'docker login' first"
  end

  def self.api_key
    config['auths']['https://index.docker.io/v1/']['auth']
  end

  def self.api_base
    'https://cloud.docker.com/api/app/v1'
  end

  def self.request(path, cached = true)
    uri_str = [api_base, namespace, path].compact.join('/')
    uri = URI.parse(uri_str)
    request_unless_cached(uri, cached)
    cache_read(uri)
  end

  def self.request_unless_cached(uri, cached = true)
    return if File.exists?(cache_file(uri)) and cached

    log(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri.request_uri)
    request.add_field('Accept', 'application/json')
    request.add_field('Authorization', "Basic #{api_key}")
    log("curl -H'Authorization: Basic #{api_key}' -H'Accept: application/json' #{uri}")

    response = http.request(request)
    validate_response(uri, response)

    File.open(cache_file(uri), 'w') do |f|
      f.puts response.body
    end
  end

  def self.validate_response(uri, response)
    json = JSON.parse(response.body)
    return unless json['error']
    log(response.body)
    raise 'Error in docker cloud response: ' + response.body
  end

  def self.reset_cache
    Dir.glob('./.cache-*.json').each do |f|
      FileUtils.rm(f)
    end
  end

  def self.cache_read(uri)
    JSON.parse(open(cache_file(uri)).read)
  end

  def self.cache_file(uri)
    ".cache-#{Base64.encode64(uri.to_s).chomp}.json"
  end
end
