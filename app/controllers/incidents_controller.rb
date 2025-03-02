class IncidentsController < ApplicationController
  # GET /incidents or /incidents.json
  def index
    @incidents = Incident.order("#{sort_column} #{sort_direction}")

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  private

  def sort_column
    %w[title description severity status created_by workspace_id].include?(params[:sort]) ? params[:sort] : "title"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
