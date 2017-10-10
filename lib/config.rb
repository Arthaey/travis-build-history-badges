require 'yaml'
require 'travis'

class Config
  attr_reader :filename

  ACCESS_TOKEN_ENV_VAR = "TRAVIS_ACCESS_TOKEN"
  TRAVIS_OWNER_ENV_VAR = "TRAVIS_OWNER"
  SCP_USERNAME_ENV_VAR = "SCP_USERNAME"
  SCP_PASSWORD_ENV_VAR = "SCP_PASSWORD"
  SCP_HOST_ENV_VAR     = "SCP_HOST"
  SCP_DIR_ENV_VAR      = "SCP_DIR"

  def initialize(filenameOrYaml = "")
    yamlExts = %w(.yml .yaml)
    if File.exist?(filenameOrYaml)
      @filename = filenameOrYaml
      @config = YAML.load_file(@filename) || {}
    elsif yamlExts.include?(File.extname(filenameOrYaml))
      raise Errno::ENOENT.new(filenameOrYaml)
    else
      @config = YAML.load(filenameOrYaml) || {}
    end

    validate!
  end

  def access_token
    @config["travis"]["access_token"]
  end

  def owner
    @config["travis"]["owner"]
  end

  def repos
    return @repos if @repos

    Travis.access_token = @config["travis"]["access_token"]
    all_repos = Travis::Repository.find_all(owner_name: owner)
    repos = all_repos.select { |r| r.active? }

    repo_whitelist = @config["travis"]["repos"]
    if repo_whitelist
      whitelisted_slugs = repo_whitelist.map { |name| "#{owner}/#{name}" }
      repos.select! { |repo| whitelisted_slugs.include?(repo.slug) }
    end

    @repos = repos
  end

  def scp_username
    @config["upload"]["username"]
  end

  def scp_password
    @config["upload"]["password"]
  end

  def scp_host
    @config["upload"]["host"]
  end

  def scp_directory
    @config["upload"]["dir"]
  end

  private

  def validate!
    @config["travis"] = {} if !@config["travis"]
    @config["upload"] = {} if !@config["upload"]

    validate_or_error!(%w[travis owner], "owner", TRAVIS_OWNER_ENV_VAR)

    if !@config["travis"]["repos"]
      validate_or_error!(%w[travis access_token], "access_token", ACCESS_TOKEN_ENV_VAR)
    end

    validate_or_error!(%w[upload username], "scp username", SCP_USERNAME_ENV_VAR)
    validate_or_error!(%w[upload password], "scp password", SCP_PASSWORD_ENV_VAR)
    validate_or_error!(%w[upload host], "scp host", SCP_HOST_ENV_VAR)
    optional_from_env_var(@config["upload"], "dir", SCP_DIR_ENV_VAR)
  end

  def validate_or_error!(keys, msg, env_var = nil)
    keys_copy = keys.clone
    hash = @config
    key = keys_copy.shift

    while (hash && hash.has_key?(key))
      break if keys_copy.empty?
      hash = hash[key]
      key = keys_copy.shift
    end

    value = optional_from_env_var(hash, key, env_var)
    raise ArgumentError.new(msg + " required") unless value
  end

  def optional_from_env_var(hash, key, env_var)
    if !hash[key] && env_var && ENV[env_var]
      hash[key] = ENV[env_var]
    end
    hash[key]
  end

end
