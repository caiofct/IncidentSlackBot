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

  private

  def valid_slack_request?
    params[:token] == ENV["SLACK_VERIFICATION_TOKEN"]
  end
end
