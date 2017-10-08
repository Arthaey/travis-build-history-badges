require 'net/scp'

img_filename = ENV["BADGE_IMAGE"] # TODO: take from create script's output

Net::SCP.upload!(
  "arthaey.com",
  ENV["FTP_USERNAME"],
  img_filename,
  "images/public/travis-build-badges/#{img_filename}",
  :ssh => { :password => ENV["FTP_PASSWORD"] }
)
