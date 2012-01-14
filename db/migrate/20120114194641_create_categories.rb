class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.string :comment
      t.integer :position
      t.integer :problem_id

      t.timestamps
    end

    add_index :categories, :problem_id
  end
end
