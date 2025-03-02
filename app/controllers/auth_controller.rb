class AuthController < ApplicationController
  SCOPE = "channels:join,channels:manage,chat:write,commands,groups:write,users:read".freeze


  def slack
    client_id = Rails.application.credentials.dig(:slack, :client_id)
    redirect_uri = "#{request.base_url}/auth/slack/callback"
    slack_url = "https://slack.com/oauth/v2/authorize?client_id=#{client_id}&scope=#{SCOPE}&redirect_uri=#{redirect_uri}"

    redirect_to slack_url, allow_other_host: true
  end

  def slack_callback
    client_id = Rails.application.credentials.dig(:slack, :client_id)
    client_secret = Rails.application.credentials.dig(:slack, :client_secret)

    code = params[:code]
    response = HTTParty.post("https://slack.com/api/oauth.v2.access", {
      body: {
        client_id: client_id,
        client_secret: client_secret,
        code: code,
        redirect_uri: "#{request.base_url}/auth/slack/callback"
      }
    })

    if response.parsed_response["ok"]
      team_id = response.parsed_response.dig("team", "id")
      access_token = response.parsed_response["access_token"]

      # Save the tokens in the database
      Workspace.find_or_create_by(team_id: team_id).update(
        access_token: access_token
      )

      render plain: "Slack app installed successfully!"
    else
      render plain: "Error installing Slack app: #{response.parsed_response['error']}"
    end
  end
end
