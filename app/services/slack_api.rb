module SlackApi
  SLACK_API_URL = "https://slack.com/api".freeze

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
    response = HTTParty.post(
      "#{SLACK_API_URL}/conversations.create",
      headers: slack_headers,
      body: { name: "incident-#{title.parameterize}", is_private: true }.to_json
    )
    JSON.parse(response.body).dig("channel", "id")
  end

  def slack_headers
    { "Authorization" => "Bearer #{ENV['SLACK_BOT_TOKEN']}", "Content-Type" => "application/json" }
  end
end
