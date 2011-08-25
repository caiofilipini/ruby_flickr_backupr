require "fileutils"
require "digest/md5"

class LocalImage
  include FileUtils

  BASE_DIR = CONFIG["base_dir"]

  def initialize(info, set_name)
    @set_name = set_name.gsub(/\s/, '')
    @local_file_name = path_from info
    mkdir_p base_dir if !File.directory?(base_dir)
  end

  def write(bytes)
    skip = false
    if File.exists? @local_file_name
      checksum = Digest::MD5.hexdigest(bytes)
      existing_md5 = Digest::MD5.file(@local_file_name).to_s
      skip = (existing_md5 == checksum)
    end
    unless skip
      File.open(@local_file_name, "w") do |file|
        file.write bytes
        puts "File saved locally at #{@local_file_name}.\n\n"
      end
    else
      puts "File already exists, skipped.\n\n"
    end
    return !skip
  end

  private

  def path_from(info)
    "#{base_dir}/#{info.id}.#{info.originalformat}"
  end

  def base_dir
    "#{BASE_DIR}/#{@set_name}"
  end
end
