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
      # Running as a background job since Slack will give a timeout if this request takes more than 3 seconds to finish
      # RootlyInteractionsJob.perform_later(payload)
      # Since render does not support workers in the free plan we are sticking to a synchronous request (Hopefully slack does not give errors on timeout)
      RootlyInteractionsService.new(payload).process_incident_submission
    end
  end

  private

  def valid_slack_request?
    params[:token] == Rails.application.credentials.dig(:slack, :verification_token)
  end
end
