class CreateWorkspaces < ActiveRecord::Migration[8.0]
  def change
    create_table :workspaces do |t|
      t.string :team_id, null: false
      t.string :access_token, null: false

      t.timestamps
    end

    add_index :workspaces, :team_id, unique: true
  end
end
