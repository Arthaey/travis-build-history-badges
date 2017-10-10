require_relative "../lib/config.rb"
require_relative "../lib/badge_creator.rb"
require_relative "../lib/badge_updater.rb"

module TravisBuildHistoryBadge
  def self.run!
    config = Config.new
    puts "Uploading badges to #{config.scp_host}/#{config.scp_directory}"

    config.repos.each do |repo|
      img_filename = BadgeCreator.create(repo)
      BadgeUpdater.update(img_filename, config)
      puts "Uploaded #{img_filename}"
    end
  end
end

TravisBuildHistoryBadge.run!
