class SlackController < ApplicationController
  skip_before_action :verify_authenticity_token

  def commands
    return head :unauthorized unless valid_slack_request?

    case params[:command]
    when "/rootly"
      render json: RootlyCommandService.new(params[:text], params[:trigger_id], params[:channel_id]).handle
    else
      render json: { text: "Unknown command." }
    end
  end

  def interactions
    payload = JSON.parse(params[:payload])
    if payload["type"] == "view_submission" && payload.dig("view", "callback_id") == "incident_submission"
      RootlyInteractionsService.new(payload).process_incident_submission
    else
      render json: { text: "Unkown interaction" }
    end
  end

  private

  def valid_slack_request?
    params[:token] == ENV["SLACK_VERIFICATION_TOKEN"]
  end
end
