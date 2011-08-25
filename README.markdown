Ruby Flickr Backupr
===

A simple Ruby script that saves all your photos locally. It is based on Flickr Sets, so it searches for all your sets and then saves all photos from that set in a local directory with the set name.

Yes, this is yet another backup script for Flickr. The goal here was to play around with Flickr API and have some fun. And yet it could be useful to someone else, so here it is.

A few steps must be followed before using the script.

Configuration
---

You must create a file named `config.yml` in the root of the project. An example configuration file is provided (see `config.yml.example`).
Your Flickr API and secret keys should be configured correctly (under `api_key` and `secret` configuration keys), or you won't be able to authenticate and get the original size of your photos.
Once you have your keys configured, go to the next step.

Authentication
---

For now, you must be authenticated in order to backup your Flickr account. There is a script called `auth.rb` that acquires a valid authentication token from Flickr, using the API and secret keys previously configured.
You will be prompted to access a Flickr URL using your favorite browser to get the token.
After getting that token, place it in your `config.yml` file under the key `auth_token` and go to the next step.

Running the script (finally!)
---

Just run `./flickr_backupr` in your terminal and wait for it to download all your Flickr files.
