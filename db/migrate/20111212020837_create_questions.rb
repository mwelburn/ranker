class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :problem_id
      t.string :position
      t.string :text
      t.integer :weight

      t.timestamps
    end

    add_index :questions, :problem_id
  end
end
