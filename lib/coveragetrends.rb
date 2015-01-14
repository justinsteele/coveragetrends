require './lib/circleci'
require 'csv'

class CoverageTrends
  def initialize(username, project)
    @username = username
    @project = project
  end

  def run
    ci = CircleCI.new(@username, @project)

    stats = ci.get_stats
    save_stats(stats)

    return 1
  end

  def save_stats(array)
    open('output/data.json', 'wb') do |f|
      f.puts array.to_json
    end
  end
end
