require "tempfile"
require_relative "test_helper.rb"
require_relative "../lib/badge_updater.rb"

class BadgeUpdaterTest < Minitest::Test
  include TravisBuildHistoryBadge

  FakeConfig = Struct.new(:scp_host, :scp_username,:scp_password, :scp_directory)

  def test_uploads_file
    begin
      file = File.new("img.png", "w")
      fakeConfig = FakeConfig.new("example.com", "ScpUser", "ScpPass", "a/b/c")

      expected_response = "scp img.png ScpUser@example.com:a/b/c/img.png"
      fake_updater_response = BadgeUpdater.update(file.path, fakeConfig)

      assert_equal(expected_response, fake_updater_response)
    ensure
     File.delete(file.path) if file
    end
  end
end
