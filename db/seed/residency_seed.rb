module ResidencySeed
  puts "In residency.rb"

  user = User.find_by_email("mwelbu2@gmail.com")

  template = user.problems.create!(:name => "Residency",
                                   :comment => "Residency Program Evaluation Guide from AAMC",
                                   :is_template => true)

  category = template.categories.create!(:name => "Education")
  template.questions.create!(:text => "Program philosophy",
                             :category_id => category.id)
  template.questions.create!(:text => "Accreditation",
                             :category_id => category.id)
  template.questions.create!(:text => "Overall curriculum",
                             :category_id => category.id)
  template.questions.create!(:text => "Rotations/electives",
                             :category_id => category.id)
  template.questions.create!(:text => "Rounds (educational vs. work)",
                             :category_id => category.id)
  template.questions.create!(:text => "Conferences",
                             :category_id => category.id)
  template.questions.create!(:text => "Number and variety of patients",
                             :category_id => category.id)
  template.questions.create!(:text => "Hospital library",
                             :category_id => category.id)
  template.questions.create!(:text => "Resident evaluations",
                             :category_id => category.id)
  template.questions.create!(:text => "Board certification of graduates",
                             :category_id => category.id)

  category = template.categories.create!(:name => "Attending Physicians/Teaching Faculty")
  template.questions.create!(:text => "Number of full-time vs. part-time",
                             :category_id => category.id)
  template.questions.create!(:text => "Research vs teaching responsibilities",
                             :category_id => category.id)
  template.questions.create!(:text => "Clincial vs. teaching skills",
                             :category_id => category.id)  
  template.questions.create!(:text => "Availability/approachability",
                             :category_id => category.id)          
  template.questions.create!(:text => "Preceptors in clinic",
                             :category_id => category.id)  
  template.questions.create!(:text => "Subspecialties represented",
                             :category_id => category.id)        
  template.questions.create!(:text => "Instruction in patient counseling/education",
                             :category_id => category.id)
  
  category = template.categories.create!(:name => "Hospital(s)")                                 
  template.questions.create!(:text => "Community or university hospital",
                             :category_id => category.id)  
  template.questions.create!(:text => "Staff physicians' support of program",
                             :category_id => category.id)                   
  template.questions.create!(:text => "Availability of consultative services",
                             :category_id => category.id)                    
  template.questions.create!(:text => "Other residency programs",
                             :category_id => category.id)       
  template.questions.create!(:text => "Type(s) of patients",
                             :category_id => category.id)  
  template.questions.create!(:text => "Hospital staff (nursing, lab, path, etc)",
                             :category_id => category.id)
  
  category = template.categories.create!(:name => "Current House Officers")
  template.questions.create!(:text => "Number per year",
                             :category_id => category.id)
  template.questions.create!(:text => "Medical schools of origin",
                             :category_id => category.id)
  template.questions.create!(:text => "Personality",
                             :category_id => category.id)
  template.questions.create!(:text => "Dependability",
                             :category_id => category.id)
  template.questions.create!(:text => "Honesty",
                             :category_id => category.id)
  template.questions.create!(:text => "Cooperativeness/get along together",
                             :category_id => category.id)
  template.questions.create!(:text => "Compatibility/can I work with them?",
                             :category_id => category.id)

  category = template.categories.create!(:name => "Work Load")
  template.questions.create!(:text => "Average number of patients per house officer (rotation, clinic)",
                             :category_id => category.id)
  template.questions.create!(:text => "Supervision - senior house officer, attending staff",
                             :category_id => category.id)
  template.questions.create!(:text => "Call schedule",
                             :category_id => category.id)
  template.questions.create!(:text => "Rounds",
                             :category_id => category.id)
  template.questions.create!(:text => "Teaching/conference responsibility",
                             :category_id => category.id)
  template.questions.create!(:text => "\"Scut\" work",
                             :category_id => category.id)
  template.questions.create!(:text => "Time for conferences",
                             :category_id => category.id)
  template.questions.create!(:text => "Clinic responsibilities",
                             :category_id => category.id)
  
  category = template.categories.create!(:name => "Benefits")
  template.questions.create!(:text => "Salary",
                             :category_id => category.id)
  template.questions.create!(:text => "Professional dues",
                             :category_id => category.id)
  template.questions.create!(:text => "Meals",
                             :category_id => category.id)
  template.questions.create!(:text => "Insurance (malpractice, health, etc)",
                             :category_id => category.id)
  template.questions.create!(:text => "Vacation",
                             :category_id => category.id)
  template.questions.create!(:text => "Paternity/Maternity/sick leave",
                             :category_id => category.id)
  template.questions.create!(:text => "Outside conferences/books",
                             :category_id => category.id)
  template.questions.create!(:text => "Moonlighting permitted",
                             :category_id => category.id)

  category = template.categories.create!(:name => "Surrounding Community")
  template.questions.create!(:text => "Size and type (urban/suburban/rural)",
                             :category_id => category.id)
  template.questions.create!(:text => "Geographic location",
                             :category_id => category.id)
  template.questions.create!(:text => "Climate and weather",
                             :category_id => category.id)
  template.questions.create!(:text => "Environmental quality",
                             :category_id => category.id)
  template.questions.create!(:text => "Socioeconomic/ethnic/religious diversity",
                             :category_id => category.id)
  template.questions.create!(:text => "Safety (from crime)",
                             :category_id => category.id)
  template.questions.create!(:text => "Cost of living(housing/food/utilities)",
                             :category_id => category.id)
  template.questions.create!(:text => "Housing (availability and quality)",
                             :category_id => category.id)
  template.questions.create!(:text => "Economy (industry/growth/recession)",
                             :category_id => category.id)
  template.questions.create!(:text => "Employment opportunities (for significant other)",
                             :category_id => category.id)
  template.questions.create!(:text => "Child care and public school systems",
                             :category_id => category.id)
  template.questions.create!(:text => "Culture (music/drama/arts/movies)",
                             :category_id => category.id)
  template.questions.create!(:text => "Entertainment (restaurants/area attractions)",
                             :category_id => category.id)
  template.questions.create!(:text => "Recreation (parks/sports/fitness facilities)",
                             :category_id => category.id)

  category = template.categories.create!(:name => "Custom")
end