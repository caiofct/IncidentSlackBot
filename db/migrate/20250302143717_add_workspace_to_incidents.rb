class AddWorkspaceToIncidents < ActiveRecord::Migration[8.0]
  def change
    Incident.delete_all
    add_reference :incidents, :workspace, null: false, foreign_key: true
  end
end
