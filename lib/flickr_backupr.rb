require "rubygems"
require "yaml"

CONFIG = YAML.load_file(File.expand_path(File.dirname(__FILE__) + "/../config.yml"))

$LOAD_PATH.unshift File.dirname(__FILE__)

require "flickr_backupr/photo_downloadr"
require "flickr_backupr/local_image"
require "flickr_backupr/backupr"

Backupr.backup!
