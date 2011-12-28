class CreateSolutions < ActiveRecord::Migration
  def change
    create_table :solutions do |t|
      t.integer :problem_id
      t.string :name
      t.string :comment
      t.integer :answer_total, :default => 0
      t.boolean :completed, :default => false

      t.timestamps
    end

    add_index :solutions, :problem_id
  end
end
