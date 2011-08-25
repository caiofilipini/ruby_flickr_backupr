require "rubygems"
require "flickraw"

CONFIG = YAML.load_file("config.yml")

FlickRaw.api_key = CONFIG["flickr"]["api_key"]
FlickRaw.shared_secret = CONFIG["flickr"]["secret"]

frob = flickr.auth.getFrob
auth_url = FlickRaw.auth_url :frob => frob, :perms => 'read'

puts "Open this URL in your browser to complete the authication process: #{auth_url}"
puts "Press Enter when you are finished."
verify = gets.strip

begin
  auth = flickr.auth.getToken :frob => frob
  login = flickr.test.login
  puts "You are now authenticated as #{login.username} with token #{auth.token}"
rescue FlickRaw::FailedResponse => e
  puts "Authentication failed: #{e.msg}"
end
