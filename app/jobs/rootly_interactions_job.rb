class RootlyInteractionsJob < ApplicationJob
  queue_as :default

  def perform(payload)
    RootlyInteractionsService.new(payload).process_incident_submission
  end
end
