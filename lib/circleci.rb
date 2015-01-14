require 'open-uri'
require 'json'

COVERAGE_DATA_PATH = "$CIRCLE_ARTIFACTS/coverage/.resultset.json"
COVERAGE_RESULTS_PATH = "$CIRCLE_ARTIFACTS/coverage/.last_run.json"

class CircleCI
  attr_accessor :username, :project

  def initialize(username, project)
    @username = username
    @project = project
  end

  def get_stats
    stats = []
    revisions = []
    get_builds.each do |build|
      if build['has_artifacts'] && !revisions.include?(build['vcs_revision'])
        stat = {}
        get_artifacts(build['build_num']).each do |artifact|
          if artifact['pretty_path'] == COVERAGE_DATA_PATH
            data = get_url(artifact['url'])['RSpec']['coverage']
            stat.merge!({ relevant_lines: get_relevant_lines(data) })
          end
          if artifact['pretty_path'] == COVERAGE_RESULTS_PATH
            stat.merge!({
              build_num: build['build_num'],
              subject: build['subject'],
              coverage: get_url(artifact['url'])['result']['covered_percent']
            })
          end
        end
        unless stat.empty?
          stats << stat
          revisions << build['vcs_revision']
        end
      end
    end
    stats
  end

  def base_url
    "https://circleci.com/api/v1/project/#{@username}/#{@project}"
  end

  def get(endpoint)
    uri = URI(base_url + endpoint)
    get_url(uri)
  end

  def get_url(url)
    uri = URI(url)
    new_query_ar = URI.decode_www_form(uri.query || '') << ['circle-token', ENV['CIRCLECI_TOKEN']]
    uri.query = URI.encode_www_form(new_query_ar)
    JSON.load(open(uri))
  end

  def get_builds(limit = 100, offset = 0, filter = 'completed')
    get("?limit=#{limit}&offset=#{offset}&filter=#{filter}").reverse
  end

  def get_artifacts(build_num)
    get("/#{build_num}/artifacts")
  end

  def get_relevant_lines(data)
    data.values.flatten.compact.count
  end
end
