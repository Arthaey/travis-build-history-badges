require 'net/scp'

module TravisBuildHistoryBadge
  class BadgeUpdater
    def self.update(filename, config)
      File.chmod(0644, filename)
      Net::SCP.upload!(
        config.scp_host,
        config.scp_username,
        filename,
        "#{config.scp_directory}/#{filename}",
        :ssh => { :password => config.scp_password }
      )
    end
  end
end
