class SlackApi
  SLACK_API_URL = "https://slack.com/api".freeze

  attr_reader :team_id, :workspace

  def initialize(team_id)
    @team_id = team_id
    @workspace = Workspace.find_by(team_id: team_id)
  end

  def open_slack_modal(modal_payload)
    HTTParty.post(
      "#{SLACK_API_URL}/views.open",
      headers: slack_headers,
      body: modal_payload.to_json
    )
  end

  def send_slack_message(channel_id, message)
    HTTParty.post(
      "#{SLACK_API_URL}/chat.postMessage",
      headers: slack_headers,
      body: { channel: channel_id, text: message }.to_json
    )
  end

  def create_slack_channel(title)
    channel_name = "incident-#{title.parameterize}"[0..79]

    response = HTTParty.post(
      "#{SLACK_API_URL}/conversations.create",
      headers: slack_headers,
      body: { name: channel_name, is_private: true }.to_json
    )
    JSON.parse(response.body).dig("channel", "id")
  end

  def invite_to_slack_channel(channel_id, user_id)
    response = HTTParty.post(
      "#{SLACK_API_URL}/conversations.invite",
      headers: slack_headers,
      body: { channel: channel_id, users: user_id }.to_json
    )
    JSON.parse(response.body).dig("channel", "id")
  end

  def slack_headers
    { "Authorization" => "Bearer #{workspace.access_token}", "Content-Type" => "application/json; charset=utf-8" }
  end
end
