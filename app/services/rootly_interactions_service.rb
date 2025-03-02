class RootlyInteractionsService
  attr_reader :payload, :team_id

  DEFAULT_DESCRIPTION = "".freeze
  DEFAULT_SEVERITY = "sev2".freeze

  def initialize(payload)
    @payload = payload
    @team_id = payload.dig("team", "id")
  end

  def process_incident_submission
    values = payload.dig("view", "state", "values")

    user_id = payload.dig("user", "id")
    title = values.dig("incident_title", "title", "value")
    description = values.dig("incident_description", "description", "value") || DEFAULT_DESCRIPTION
    severity = values.dig("incident_severity", "severity", "selected_option", "value") || DEFAULT_SEVERITY

    channel_id = slack_api.create_slack_channel(title)
    slack_api.invite_to_slack_channel(channel_id, user_id)

    Incident.create!(
      title: title,
      description: description,
      severity: severity,
      status: "open",
      created_by: user_id,
      slack_channel_id: channel_id,
      workspace: slack_api.workspace
    )

    { response_action: "clear", text: "Incident declared successfully!" }
  rescue StandardError => e
    Rails.logger.error "Failed to create incident: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")

    slack_api.send_slack_message(user_id, ":warning: Failed to declare incident. Please try again or contact support.")

    { response_action: "errors", errors: { incident_title: "Something went wrong. Try again later." } }
  end

  def slack_api
    @slack_api ||= SlackApi.new(team_id)
  end
end
