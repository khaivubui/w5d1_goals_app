class CreateGoals < ActiveRecord::Migration[5.1]
  def change
    create_table :goals do |t|
      t.integer :user_id, null: false
      t.string :body, null: false
      t.string :goal_type, default: 'PRIVATE'
      t.timestamps
    end

    add_index :goals, :user_id
  end
end
