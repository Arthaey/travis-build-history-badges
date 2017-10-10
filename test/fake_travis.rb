require "travis"

FakeRepo = Struct.new(:slug, :active) do
  def active?
    active
  end

  def each_build(&block)
    @builds ||= [
      FakeBuild.new(25, "red"),
      FakeBuild.new(100, "yellow"),
      FakeBuild.new(50, "green"),
    ]
    @builds.each(&block)
  end

  def builds=(builds)
    @builds = builds
  end
end

FakeBuild = Struct.new(:duration, :color)

class << Travis
  def access_token=(token); end
end

class << Travis::Repository
  def find_all(owner_name)
    [
      FakeRepo.new("MyUsername/foo", true),
      FakeRepo.new("MyUsername/qux", false),
      FakeRepo.new("MyUsername/bar", true),
    ]
  end
end
