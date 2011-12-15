class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.integer :question_id
      t.integer :solution_id
      t.integer :rating
      t.string :comment

      t.timestamps
    end

    add_index :answers, :question_id
  end
end
