module UserSeed
  puts "In user_seed.rb"

  if User.find_by_email("mwelbu2@gmail.com").nil?
    User.create!(:name => "Michael Welburn", :email => "mwelbu2@gmail.com", :password => "foobar", :password_confirmation => "foobar")
  end
end
