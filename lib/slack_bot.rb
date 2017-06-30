require 'slack-ruby-client'


class SlackBot
  def initialize
    Slack.configure do |config|
      config.token = 'xoxb-195025932757-iGPkE0qK8eIZcwkjUI2HWvpc'
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
            # pretext: 'foobar',
            author_name: "User: #{options[:username]}",
            author_link: options[:user_url],
            author_icon: options[:user_avatar_url],
            title: "#{options[:pr_title]} [#{options[:labels].join(", ")}]",
            title_link: options[:pr_url],
            mrkdwn_in: ['text'],
            text: "*+#{options[:additions]} / -#{options[:deletions]} lines changed, " +
            "#{options[:files_changed]} files changed.*\n" +
            "#{options[:pr_body]} <http://someurl.com|like this>",
            # fields: [
            #     {
            #         title: 'Branch',
            #         value: options[:branch_name],
            #         short: true
            #     },
            #     {
            #         title: 'Labels',
            #         value: "",
            #         short: true
            #     },
            #     {
            #         title: 'Patch Summary',
            #         value: ,
            #         short: true
            #     }
            # ],
            image_url: '',
            thumb_url: '',
            footer: 'Github Bot',
            footer_icon: 'https://platform.slack-edge.com/img/default_application_icon.png',
        }
    ]
  end

  def post_to_channel(channel: 'github', text: '', attachments: nil)
    @client.chat_postMessage(channel: "##{channel}", text: '', as_user: true, attachments: @attachments)
  end
end






