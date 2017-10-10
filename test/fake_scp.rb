require "net/scp"

module Net
  class SCP
    def self.upload!(host, username, local, remote, options={}, &progress)
      "scp #{local} #{username}@#{host}:#{remote}"
    end
  end
end
