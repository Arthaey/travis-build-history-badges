require "simplecov"
SimpleCov.start do
  add_filter "lib/spark_pr.rb"
end

require "minitest/autorun"

require_relative "fake_travis.rb"
require_relative "fake_scp.rb"
