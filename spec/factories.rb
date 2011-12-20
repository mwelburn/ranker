# By using the symbol ':user', we get Factory Girl to simulate the User model
Factory.define :user do |user|
  user.name                   "Test User"
  user.email                  "example@test.com"
  user.password               "foobar"
  user.password_confirmation  "foobar"
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

Factory.sequence :name do |n|
  "Test Name #{n}"
end

Factory.sequence :text do |n|
  "Test Text #{n}"
end

Factory.define :problem do |problem|
  problem.name "Foo bar"
  problem.comment "Comment"
  problem.public false
  problem.association :user
end

Factory.define :solution do |solution|
  solution.name "Solution name"
  solution.comment "Test solution"
  solution.association :problem
end

Factory.define :question do |question|
  question.text "Question text"
  question.position 0
  question.weight 1
  question.association :problem
end

Factory.define :answer do |answer|
  answer.rating 1
  answer.comment "Comment"
  answer.association :solution
  answer.association :question
end