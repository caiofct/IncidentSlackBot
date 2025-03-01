class IncidentsController < ApplicationController
  # GET /incidents or /incidents.json
  def index
    @incidents = Incident.all
  end
end
