require 'slack-ruby-client'

class SlackBot
  def initialize
    Slack.configure do |config|
      # config.token = 'xoxb-195025932757-jlbEhsZGGSzsSdSFEhHdzgHF'
      config.token = 'xoxb-3580201791-rcLXqa9qMInUvoPijOJSq8Ia'
      fail 'Missing ENV[SLACK_API_TOKEN]!' unless config.token
    end

    @client = Slack::Web::Client.new

    @client.auth_test
  end

  def build_message(options={})
    @attachments = [
        {
            fallback: 'Required plain-text summary of the attachment.',
            color: '#36a64f',
            author_name: "User: #{options[:username]}",
            author_link: options[:user_url],
            author_icon: options[:user_avatar_url],
            title: "#{options[:pr_title]} [#{options[:labels].join(", ")}]",
            title_link: options[:pr_url],
            mrkdwn_in: ['text'],
            text: "#{options[:pr_body]}",
            footer: "+#{options[:additions]} / -#{options[:deletions]} lines changed, " +
                "#{options[:files_changed]} files changed."
        }
    ]
  end

  def post_to_channel(channel: 'beng_prs', text: '', attachments: nil)
    @client.chat_postMessage(channel: "##{channel}", text: '', as_user: true, attachments: @attachments)
  end
end
