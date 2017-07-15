require 'slack-ruby-client'

class SlackBot
  def initialize
    Slack.configure do |config|
      config.token = ENV["SLACK_API_TOKEN"]
      fail 'Missing ENV[SLACK_API_TOKEN]!' unless config.token
    end

    @client = Slack::RealTime::Client.new
    @client.on :message do |data|
      case data.text
        when 'bot hi' then
          client.message channel: data.channel, text: "Hi <@#{data.user}>!"
        when /^bot/ then
          client.message channel: data.channel, text: "Sorry <@#{data.user}>, what?"
      end
    end
    # @client.auth_test
    @client.start!
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

  def post_to_channel(channel: 'github', text: '', attachments: nil)
    @client.chat_postMessage(channel: "##{channel}", text: '', as_user: true, attachments: @attachments)
  end
end

slackbot = SlackBot.new



