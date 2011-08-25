
class PhotoDownloader
  include HTTParty
end

class LocalImage
  include FileUtils

  BASE_DIR = "/Users/cfilipini/Pictures/Flickr/Backup"

  def initialize(info, set_name)
    @set_name = set_name
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
        puts "File saved locally at #{@local_file_name}."
      end
    else
      puts "File already existed, skipped."
    end
  end

  private

  def path_from(info)
    "#{base_dir}/#{info.id}.#{info.originalformat}"
  end

  def base_dir
    "#{BASE_DIR}/#{@set_name}"
  end
end

FlickRaw.api_key = "1474a4275423fff7e997a0ad33a97c50"
FlickRaw.shared_secret = "ae4ec5327ba27f85"
access_token = "72157627510346432-ce086e3780be8edd"
auth = flickr.auth.checkToken :auth_token => access_token
puts "Logged in as #{auth.user.username}."

user_id = auth.user.nsid
puts "Searching photo sets from user #{user_id}..."
sets = flickr.photosets.getList(:user_id => user_id)

sets.each do |set|
  set_name = flickr.photosets.getInfo(:photoset_id => set.id).title

  puts "Searching photos from set #{set_name}..."
  photos = flickr.photosets.getPhotos(:photoset_id => set.id)

  puts "Found #{photos.total} photo(s) in #{photos.pages} page(s)."

  total = photos.pages
  total = 1

  1.upto(total) do |page_number|
    page_photos = flickr.photosets.getPhotos(:photoset_id => set.id, :page => page_number)
    puts "#{page_photos.photo.size} photo(s) in page #{page_photos.page}"

    page_photos.photo.each do |photo|
      info = flickr.photos.getInfo :photo_id => photo.id
      original_url = FlickRaw.url_o info
      puts "Found photo ##{photo.id}. Original size at #{original_url}"

      puts "Downloading #{original_url}..."
      image_bytes = PhotoDownloader.get(original_url).body
      LocalImage.new(info, set_name).write image_bytes
      break
    end
  end
  break
end

