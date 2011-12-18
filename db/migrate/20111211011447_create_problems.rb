class CreateProblems < ActiveRecord::Migration
  def change
    create_table :problems do |t|
      t.integer :user_id
      t.string :name
      t.string :comment

      t.timestamps
    end

    add_index :problems, :user_id
  end
end
