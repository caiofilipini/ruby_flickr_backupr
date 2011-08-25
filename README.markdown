Ruby Flickr Backupr
===

A simple Ruby script that saves all your photos locally.

Yes, this is yet another backup script for Flickr. The goal here was to play around with Flickr API and have some fun. And yet it could be useful to someone else, so here it is.

A few important steps must be followed before using the script. Be sure to read on.

Configuration
---

You must create a file named `config.yml` in the root of the project. An example configuration file is provided (see `config.yml.example`).
Your Flickr API and secret keys should be configured correctly (under `api_key` and `secret` configuration keys), or you won't be able to authenticate and get the original size of your photos.
Once you have your keys configured, go to the next step.

Authentication
---

For now, you must be authenticated in order to backup your Flickr account. There is a script called `auth.rb` that acquires a valid authentication token from Flickr, using the API and secret keys previously configured.
Run `ruby auth.rb` in your terminal. You will be prompted to access a Flickr URL using your favorite browser to get the token.
After getting that token, place it in your `config.yml` file under the key `auth_token` and go to the next step.

This method is a little inconvenient, and I shall improve it soon.

Running the script (finally!)
---

Just run `./flickr_backupr` in your terminal and wait for it to download all your Flickr files.

How it works
---

The script searches for your photo sets, and for every photo on each set, it downloads a binary copy of the original size. Using the base directory configured in `config.yml`, it then creates on subdirectory for each set, using the original set name (with spaces removed). It assumes the photo ID provided by Flickr as the name for the file. But before actually writing the file to disk, if that file already exists, it runs a MD5 checksum to avoid rewriting the file.
