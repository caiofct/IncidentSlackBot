class CreateIncidents < ActiveRecord::Migration[8.0]
  def change
    create_table :incidents do |t|
      t.string :title, null: false
      t.text :description
      t.integer :severity, null: false
      t.integer :status, null: false
      t.string :created_by, null: false
      t.string :slack_channel_id, null: false
      t.datetime :resolved_at

      t.timestamps
    end

    add_index :incidents, [ :slack_channel_id, :status ], unique: true
  end
end
