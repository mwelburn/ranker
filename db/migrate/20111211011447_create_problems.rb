class CreateProblems < ActiveRecord::Migration
  def change
    create_table :problems do |t|
      t.integer :user_id
      t.string :name
      t.string :comment
      t.integer :question_total, :default => 0
      t.boolean :is_template, :default => false
      t.integer :template_id

      t.timestamps
    end

    add_index :problems, :user_id
  end
end
