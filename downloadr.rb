class Backupr
  def self.backup!
    FlickRaw.api_key = CONFIG["flickr"]["api_key"]
    FlickRaw.shared_secret = CONFIG["flickr"]["secret"]
    access_token = CONFIG["flickr"]["auth_token"]

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
          image_bytes = PhotoDownloadr.get(original_url).body
          LocalImage.new(info, set_name).write image_bytes
        end
      end
    end
  end
end
