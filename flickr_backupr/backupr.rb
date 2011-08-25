require "flickraw"

class Backupr
  SEPARATOR = "#####################"

  def self.backup!
    start_time = Time.now
    saved = 0
    skipped = 0
    set_name = nil
    user_id = login

    puts "Searching photo sets from user #{user_id}..."
    sets = flickr.photosets.getList(:user_id => user_id)
    puts "Found #{sets.size} sets."

    sets.each_with_index do |set, index|
      puts "Completed downloading photos from set \"#{set_name}\".\n\n" if index > 0

      set_name = flickr.photosets.getInfo(:photoset_id => set.id).title

      puts "Searching photos from set \"#{set_name}\"..."
      photos = flickr.photosets.getPhotos(:photoset_id => set.id)
      puts "Found #{photos.total} photo(s) in #{photos.pages} page(s)."

      total = photos.pages

      1.upto(total) do |page_number|
        puts "Searching photos from page ##{page_number}..."
        page_photos = flickr.photosets.getPhotos(:photoset_id => set.id, :page => page_number)
        puts "#{page_photos.photo.size} photo(s) in page ##{page_photos.page}\n\n"

        page_photos.photo.each do |photo|
          info = flickr.photos.getInfo :photo_id => photo.id
          original_url = FlickRaw.url_o info
          puts "Found photo ##{photo.id}. Original size at #{original_url}"

          puts "Downloading #{original_url}..."
          image_bytes = PhotoDownloadr.get(original_url).body
          puts "Download of #{image_bytes.size} bytes completed."

          if LocalImage.new(info, set_name).write(image_bytes)
            saved += 1
          else
            skipped += 1
          end
        end
      end
    end

    end_time = Time.now
    time_elapsed = diff start_time, end_time

    puts SEPARATOR
    puts "Finished successfully in #{time_elapsed}. #{saved > 0 ? saved : 'No'} photo(s) backed up, #{skipped > 0 ? skipped : 'No'} photo(s) skipped.\n\n"
  end

  def self.login
    puts "Preparing to backup your Flickr..."

    FlickRaw.api_key = CONFIG["flickr"]["api_key"]
    FlickRaw.shared_secret = CONFIG["flickr"]["secret"]
    access_token = CONFIG["flickr"]["auth_token"]

    auth = flickr.auth.checkToken :auth_token => access_token
    puts "Logged in as #{auth.user.username}."
    puts SEPARATOR

    auth.user.nsid
  end

  def self.diff(start_time, end_time)
    format = "%.2f"
    diff_in_seconds = end_time - start_time
    if diff_in_seconds < 60
      "#{format % diff_in_seconds} seconds"
    else
      "#{format % (diff_in_seconds / 60)} minutes"
    end
  end
end
