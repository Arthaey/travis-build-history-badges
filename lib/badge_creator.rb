require_relative 'spark_pr.rb'

module TravisBuildHistoryBadge
  class BadgeCreator

    BUILD_COLORS = {
      green:  SparkCanvas::GREEN,
      yellow: SparkCanvas::YELLOW,
      red:    SparkCanvas::RED,
    }

    def self.create(repo)
      filename = repo.slug.gsub("/", "-") + ".png"

      data = []
      repo.each_build do |build|
        color = BUILD_COLORS[build.color.to_sym] || SparkCanvas::GRAY
        data.push(build.duration => color)
      end

      if data.nil? || data.empty?
        raise "no builds found for #{repo.slug}"
      end

      File.open(filename, "wb" ) do |png|
        png << Spark.plot(
          data,
          :type => "bar",
          :height => 20,
          :width => 100,
        )
      end

      filename
    end

  end
end
