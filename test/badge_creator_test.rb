require_relative "test_helper.rb"
require_relative "../lib/badge_creator.rb"

class BadgeCreatorTest < Minitest::Test
  include TravisBuildHistoryBadge

  def setup
    @repo = FakeRepo.new("MyUsername/my-repo", true)
  end

  def test_returns_the_image_filename
    generated_file = BadgeCreator.create(@repo)
    assert_equal("MyUsername-my-repo.png", generated_file)
    FileUtils.rm(generated_file)
  end

  def test_generates_image
    expected_file = "test/images/MyUsername-my-repo.png"
    generated_file = BadgeCreator.create(@repo)
    assert FileUtils.identical?(expected_file, generated_file), "files don't match"
    FileUtils.rm(generated_file)
  end

  def test_does_not_generate_image_when_there_is_no_data
    repo_no_builds = FakeRepo.new("MyUsername/my-repo")
    repo_no_builds.builds = []
    assert_raises("no builds") { BadgeCreator.create(repo_no_builds) }
  end
end
