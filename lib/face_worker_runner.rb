require 'simple_worker'
require 'json'
require 'open-uri'
require 'rest-client'

def get_images_twitpic(username)
  json         = open('http://api.twitpic.com/2/users/show.json?username='+username).read
  images       = JSON.parse(json)
  total_images = images["photo_count"]
  images_list  =[]
  if total_images && total_images.to_i >0
    total_pages = (total_images.to_f/20).ceil
    1.upto(total_pages) do |page|
      json   = open('http://api.twitpic.com/2/users/show.json?username='+username+'&page=' + page.to_s).read
      images = JSON.parse(json)
      images["images"].each do |image|
        images_list << "http://twitpic.com/show/thumb/" + image["short_id"]
      end
    end
  end
  images_list
end

SETTINGS = YAML.load_file('../config/face.yaml')

SimpleWorker.configure do |config|
  config.access_key = SETTINGS["sw_access_key"]
  config.secret_key = SETTINGS["sw_secret_key"]
end

load "face_worker.rb"
tw_username       = "Twilight"
fw                = FaceWorker.new
fw.images_list    = get_images_twitpic(tw_username)
fw.api_key        = SETTINGS["api_key"]
fw.api_secret     = SETTINGS["api_secret"]
fw.email_username = SETTINGS["email_username"]
fw.email_password = SETTINGS["email_password"]
fw.email_domain   = SETTINGS["email_domain"]
fw.send_to        = "user@email.com"
fw.title          = "Twitpic account #{tw_username}"
fw.queue