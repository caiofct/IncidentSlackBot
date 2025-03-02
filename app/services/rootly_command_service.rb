class RootlyCommandService
  attr_reader :text, :team_id, :trigger_id, :channel_id

  def initialize(text, team_id, trigger_id, channel_id)
    @text = text
    @team_id = team_id
    @trigger_id = trigger_id
    @channel_id = channel_id
  end

  def handle
    action, title = text.split(" ", 2)

    case action
    when "declare"
      open_incident_modal(title)
    when "resolve"
      resolve_incident
    else
      { text: "Usage: `/rootly declare <title>` or `/rootly resolve`" }
    end
  end

  private

  def open_incident_modal(title)
    modal_payload = {
      trigger_id: trigger_id,
      view: {
        type: "modal",
        callback_id: "incident_submission",
        title: { type: "plain_text", text: "Declare Incident" },
        submit: { type: "plain_text", text: "Submit" },
        blocks: [
          {
            type: "input",
            block_id: "incident_title",
            label: { type: "plain_text", text: "Title" },
            element: { type: "plain_text_input", action_id: "title", initial_value: title || "" }
          },
          {
            type: "input",
            optional: true,
            block_id: "incident_description",
            label: { type: "plain_text", text: "Description" },
            element: { type: "plain_text_input", action_id: "description", multiline: true }
          },
          {
            type: "input",
            optional: true,
            block_id: "incident_severity",
            label: { type: "plain_text", text: "Severity" },
            element: {
              type: "static_select",
              action_id: "severity",
              options: [
                { text: { type: "plain_text", text: "Sev0" }, value: "sev0" },
                { text: { type: "plain_text", text: "Sev1" }, value: "sev1" },
                { text: { type: "plain_text", text: "Sev2" }, value: "sev2" }
              ]
            }
          }
        ]
      }
    }

    response = slack_api.open_slack_modal(modal_payload)

    { text: response.success? ? "Opening incident modal..." : "Error opening incident modal. Please try again!" }
  end

  def resolve_incident
    incident = slack_api.workspace.incidents.find_by(slack_channel_id: channel_id, status: "open")
    return { text: "No active incident found in this channel." } unless incident

    incident.update!(status: "resolved", resolved_at: Time.current)
    duration = ((incident.resolved_at - incident.created_at) / 60).round

    slack_api.send_slack_message(channel_id, "Incident *#{incident.title}* resolved in *#{duration} minutes*.")

    { text: "Command executed successfully!" }
  end

  def slack_api
    @slack_api ||= SlackApi.new(team_id)
  end
end
