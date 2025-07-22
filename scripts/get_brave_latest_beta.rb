#!/usr/bin/env ruby

require 'net/http'
require 'uri'
require 'json'

# --- Environment Variables ---
GITHUB_TOKEN = ENV['GITHUB_TOKEN']
REQUESTED_VERSION = ENV['REQUESTED_VERSION']

# --- Constants ---
REPO_OWNER = 'brave'
REPO_NAME = 'brave-browser'
ARTIFACT_NAME = 'BraveMonoarm64.apk'

# --- Helpers ---
def log_info(msg)
  STDERR.puts "[INFO] #{msg}"
end

def log_error(msg)
  STDERR.puts "[ERROR] #{msg}"
end

def panic(msg)
  log_error msg
  exit 1
end

# Helper function for GitHub API requests
def github_api_request(path)
  uri = URI("https://api.github.com/repos/#{REPO_OWNER}/#{REPO_NAME}/#{path}")
  request = Net::HTTP::Get.new(uri)
  request['Authorization'] = "token #{GITHUB_TOKEN}"
  request['Accept'] = 'application/vnd.github.v3+json' # Use GitHub API v3

  log_info "Making GitHub API request to: #{uri}"

  response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
    http.request(request)
  end

  unless response.is_a?(Net::HTTPSuccess)
    log_error "GitHub API request failed for: #{uri}"
    log_error "Status Code: #{response.code}, Response Body: #{response.body}"
    exit 1
  end

  JSON.parse(response.body)
rescue JSON::ParserError => e
  log_error "Failed to parse JSON response: #{e.message}"
  exit 1
rescue StandardError => e
  log_error "An unexpected error occurred during API request: #{e.message}"
  exit 1
end

# --- Main Script ---

panic "GITHUB_TOKEN environment variable is not set." unless GITHUB_TOKEN

log_info "Fetching releases for #{REPO_OWNER}/#{REPO_NAME} repository..."
releases = github_api_request('releases')

target_release = nil

if REQUESTED_VERSION && !REQUESTED_VERSION.empty?
  # If a specific version is requested
  target_tag = "v#{REQUESTED_VERSION}"
  log_info "Requested version: #{REQUESTED_VERSION}. Searching for release with tag '#{target_tag}'..."
  target_release = releases.find { |release| release['tag_name'] == target_tag }

  unless target_release
    panic "Could not find a release with tag '#{target_tag}'."
  end
else
  # If no specific version is requested, find the latest 'Beta' pre-release
  log_info "No specific version requested. Searching for the latest 'Beta' pre-release..."
  target_release = releases.find do |release|
    release['prerelease'] && release['name']&.start_with?('Beta')
  end

  unless target_release
    panic "Could not find any pre-release starting with 'Beta'."
  end
end

log_info "Found target release: '#{target_release['name']}' (tag: #{target_release['tag_name']})"

# Find the desired artifact (asset) within the target release
target_asset = target_release['assets'].find { |asset| asset['name'] == ARTIFACT_NAME }

unless target_asset
  panic "Could not find artifact '#{ARTIFACT_NAME}' in release '#{target_release['name']}'."
end

download_url = target_asset['browser_download_url']

# Print tag name and download URL to stdout
puts target_release['tag_name']
puts download_url
