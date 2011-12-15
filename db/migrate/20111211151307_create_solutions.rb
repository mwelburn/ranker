class CreateSolutions < ActiveRecord::Migration
  def change
    create_table :solutions do |t|
      t.integer :problem_id
      t.string :name
      t.string :comment

      t.timestamps
    end

    add_index :solutions, :problem_id
  end
end
