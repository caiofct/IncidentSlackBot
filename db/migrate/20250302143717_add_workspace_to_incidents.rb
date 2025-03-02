class AddWorkspaceToIncidents < ActiveRecord::Migration[8.0]
  def change
    add_reference :incidents, :workspace, null: false, foreign_key: true
  end
end
