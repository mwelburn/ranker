# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120211211328) do

  create_table "answers", :force => true do |t|
    t.integer  "question_id"
    t.integer  "solution_id"
    t.integer  "rating"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "answers", ["question_id"], :name => "index_answers_on_question_id"
  add_index "answers", ["solution_id"], :name => "index_answers_on_solution_id"

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.string   "comment"
    t.integer  "position"
    t.integer  "problem_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["problem_id"], :name => "index_categories_on_problem_id"

  create_table "problems", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "comment"
    t.integer  "question_total", :default => 0
    t.boolean  "is_template",    :default => false
    t.integer  "template_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "problems", ["user_id"], :name => "index_problems_on_user_id"

  create_table "questions", :force => true do |t|
    t.integer  "problem_id"
    t.integer  "position"
    t.string   "text"
    t.integer  "weight"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "questions", ["category_id"], :name => "index_questions_on_category_id"
  add_index "questions", ["problem_id"], :name => "index_questions_on_problem_id"

  create_table "solutions", :force => true do |t|
    t.integer  "problem_id"
    t.string   "name"
    t.string   "comment"
    t.integer  "answer_total", :default => 0
    t.boolean  "completed",    :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "solutions", ["problem_id"], :name => "index_solutions_on_problem_id"

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "facebook_id"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
