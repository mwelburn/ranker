class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :problem_id
      t.integer :position
      t.string :text
      t.integer :weight
      t.integer :category_id

      t.timestamps
    end

    add_index :questions, :problem_id
    add_index :questions, :category_id
  end
end
