require 'net/http'
require 'json'

class PullRequestEventsController < ApplicationController

  before_action :validate_request

  def index
  end

  def create
    # TODO: filter by team
    pull_request = params[:pull_request]
    state = pull_request[:state]
    if state == 'open'
      pr_id = pull_request[:id]
      url = pull_request[:html_url]
      patch_url = pull_request[:patch_url]
      title = pull_request[:title]
      base_branch = pull_request[:base][:ref]
      compare_branch = pull_request[:head][:ref]
      user = pull_request[:user][:login]
      user_url = pull_request[:user][:html_url]
      user_teams_url = pull_request[:user][:teams_url]
      user_avatar_url = pull_request[:user][:avatar_url]
      body = pull_request[:body]
      created_at = pull_request[:created_at]
      updated_at = pull_request[:updated_at]
      mergeable = pull_request[:mergeable]
      num_commits = pull_request[:commits]
      additions = pull_request[:additions]
      deletions = pull_request[:deletions]
      changed_files = pull_request[:changed_files]

      issue_url = pull_request[:issue_url]

      label_url = issue_url + '/labels'
      label_uri = URI(label_url)
      response = Net::HTTP.get(label_uri)
      labels = JSON.parse(response).map {|label| label['name']}

      slackbot = SlackBot.new

      slackbot.build_message({username: user,
                              user_url: user_url,
                              user_avatar_url: user_avatar_url,
                              pr_title: title,
                              pr_url: url,
                              pr_body: body,
                              additions: additions,
                              deletions: deletions,
                              files_changed: changed_files,
                              labels: labels
                             })

      slackbot.post_to_channel
    end
  end

  private

  # authenticates using github secret token ala https://developer.github.com/webhooks/securing/
  def validate_request
    payload_body = request.body.read
    signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), ENV['GITHUB_TOKEN'], payload_body)
    request_signature = request.headers['X-Hub-Signature']
    render status: :unauthorized unless Rack::Utils.secure_compare(signature, request_signature)
  end

end
