require_relative "test_helper.rb"
require_relative "../lib/config.rb"

class ConfigTest < Minitest::Test

  ORIG_ACCESS_TOKEN = ENV[Config::ACCESS_TOKEN_ENV_VAR]
  ORIG_TRAVIS_OWNER = ENV[Config::TRAVIS_OWNER_ENV_VAR]
  ORIG_SCP_USERNAME = ENV[Config::SCP_USERNAME_ENV_VAR]
  ORIG_SCP_PASSWORD = ENV[Config::SCP_PASSWORD_ENV_VAR]
  ORIG_SCP_HOST     = ENV[Config::SCP_HOST_ENV_VAR]
  ORIG_SCP_DIR      = ENV[Config::SCP_DIR_ENV_VAR]

  GOOD_YAML = <<~YAML_END
    travis:
      owner: MyUsername
      repos:
        - foo
        - bar
    upload:
      username: ScpUsername
      password: ScpPassword
      host: example.com
      dir: path/to/upload/to
  YAML_END

  def setup
    @config = Config.new(GOOD_YAML)
    @repos = [
      FakeRepo.new("MyUsername/foo", true),
      FakeRepo.new("MyUsername/bar", true),
    ]
  end

  def teardown
    ENV[Config::ACCESS_TOKEN_ENV_VAR] = ORIG_ACCESS_TOKEN
    ENV[Config::TRAVIS_OWNER_ENV_VAR] = ORIG_TRAVIS_OWNER
    ENV[Config::SCP_USERNAME_ENV_VAR] = ORIG_SCP_USERNAME
    ENV[Config::SCP_PASSWORD_ENV_VAR] = ORIG_SCP_PASSWORD
    ENV[Config::SCP_HOST_ENV_VAR]     = ORIG_SCP_HOST
    ENV[Config::SCP_DIR_ENV_VAR]      = ORIG_SCP_DIR
  end

  def test_allows_string_config
    assert(!@config.nil?)
  end

  def test_has_owner_name_when_explicitly_set
    assert_equal("MyUsername", @config.owner)
  end

  def test_has_explicitly_defined_repos
    assert_equal(@repos, @config.repos)
  end

  def test_gets_repos_from_Travis
    yaml = <<~YAML_END
      travis:
        access_token: 123abc
        owner: MyUsername
      upload:
        username: ScpUsername
        password: ScpPassword
        host: example.com
    YAML_END

    config = Config.new(yaml)
    assert_equal(@repos, config.repos)
  end

  def test_has_upload_username_when_explicitly_set
    assert_equal("ScpUsername", @config.scp_username)
  end

  def test_has_upload_password_when_explicitly_set
    assert_equal("ScpPassword", @config.scp_password)
  end

  def test_has_upload_host_when_explicitly_set
    assert_equal("example.com", @config.scp_host)
  end

  def test_has_upload_directory_when_explicitly_set
    assert_equal("path/to/upload/to", @config.scp_directory)
  end

  def test_throws_if_no_config_file
    assert_raises(Errno::ENOENT) { config = Config.new("nonexistant.yml") }
  end

  def test_throws_if_empty_string_config
    assert_raises("filename or YAML string") { config = Config.new("") }
  end

  def test_requires_Travis_owner_name
    yaml = <<~YAML_END
      travis:
        foo: bar
    YAML_END

    ENV[Config::TRAVIS_OWNER_ENV_VAR] = nil
    assert_raises("owner required") { config = Config.new(yaml) }
  end

  def test_uses_env_var_for_access_token
    yaml = <<~YAML_END
      travis:
        owner: MyUsername
      upload:
        username: ScpUsername
        password: ScpPassword
        host: example.com
    YAML_END

    ENV[Config::ACCESS_TOKEN_ENV_VAR] = "123abc"

    config = Config.new(yaml)
    assert_equal("123abc", config.access_token)
  end

  def test_uses_env_var_for_travis_owner_name
    yaml = <<~YAML_END
      travis:
        access_token: 123abc
      upload:
        username: ScpUsername
        password: ScpPassword
        host: example.com
    YAML_END

    ENV[Config::TRAVIS_OWNER_ENV_VAR] = "MyUsername"

    config = Config.new(yaml)
    assert_equal("MyUsername", config.owner)
  end

  def test_requires_access_token_when_getting_repos_from_Travis
    yaml = <<~YAML_END
      travis:
        owner: MyUsername
      upload:
        username: ScpUsername
        password: ScpPassword
        host: example.com
    YAML_END

    ENV[Config::ACCESS_TOKEN_ENV_VAR] = nil
    assert_raises("access_token required") { config = Config.new(yaml) }
  end

  def test_uses_env_var_for_upload_username
    yaml = <<~YAML_END
      travis:
        access_token: 123abc
        owner: MyUsername
        repos:
          - foo
      upload:
        password: ScpPassword
        host: example.com
    YAML_END

    ENV[Config::SCP_USERNAME_ENV_VAR] = "ScpUsername"

    config = Config.new(yaml)
    assert_equal("ScpUsername", config.scp_username)
  end

  def test_uses_env_var_for_upload_password
    yaml = <<~YAML_END
      travis:
        access_token: 123abc
        owner: MyUsername
        repos:
          - foo
      upload:
        username: ScpUsername
        host: example.com
    YAML_END

    ENV[Config::SCP_PASSWORD_ENV_VAR] = "ScpPassword"

    config = Config.new(yaml)
    assert_equal("ScpPassword", config.scp_password)
  end

  def test_uses_env_var_for_upload_host
    yaml = <<~YAML_END
      travis:
        access_token: 123abc
        owner: MyUsername
        repos:
          - foo
      upload:
        username: ScpUsername
        password: ScpPassword
    YAML_END

    ENV[Config::SCP_HOST_ENV_VAR] = "example.com"

    config = Config.new(yaml)
    assert_equal("example.com", config.scp_host)
  end

  def test_uses_env_var_for_upload_directory
    yaml = <<~YAML_END
      travis:
        access_token: 123abc
        owner: MyUsername
        repos:
          - foo
      upload:
        username: ScpUsername
        password: ScpPassword
        host: example.com
    YAML_END

    ENV[Config::SCP_DIR_ENV_VAR] = "path/to/upload/to"

    config = Config.new(yaml)
    assert_equal("path/to/upload/to", config.scp_directory)
  end

  def test_requires_upload_username
    yaml = <<~YAML_END
      travis:
        access_token: 123abc
        owner: MyUsername
        repos:
          - foo
      upload:
        password: ScpPassword
        host: example.com
    YAML_END

    ENV[Config::SCP_USERNAME_ENV_VAR] = nil
    assert_raises("scp username required") { config = Config.new(yaml) }
  end

  def test_requires_upload_password
    yaml = <<~YAML_END
      travis:
        access_token: 123abc
        owner: MyUsername
        repos:
          - foo
      upload:
        username: ScpUsername
        host: example.com
    YAML_END

    ENV[Config::SCP_PASSWORD_ENV_VAR] = nil
    assert_raises("scp password required") { config = Config.new(yaml) }
  end

  def test_requires_upload_host
    yaml = <<~YAML_END
      travis:
        access_token: 123abc
        owner: MyUsername
        repos:
          - foo
      upload:
        username: ScpUsername
        password: ScpPassword
    YAML_END

    ENV[Config::SCP_HOST_ENV_VAR] = nil
    assert_raises("scp host required") { config = Config.new(yaml) }
  end
end
