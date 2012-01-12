module ResidencySeed
  puts "In residency.rb"

  user = User.find_by_email("mwelbu2@gmail.com")

  template = user.problems.create!(:name => "Residency", :is_template => true)

  template.questions.create!(:text => "Program philosophy")
end