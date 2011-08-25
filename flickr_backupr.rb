require "rubygems"
require "yaml"

CONFIG = YAML.load_file("config.yml")

require File.expand_path("flickr_backupr/photo_downloadr")
require File.expand_path("flickr_backupr/local_image")
require File.expand_path("flickr_backupr/backupr")

Backupr.backup!
