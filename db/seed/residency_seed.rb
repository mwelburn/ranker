module ResidencySeed
  puts "In residency.rb"

  user = User.find_by_email("mwelbu2@gmail.com")

  template = user.problems.create!(:name => "Residency",
                                   :comment => "Residency Program Evaluation Guide from AAMC",
                                   :is_template => true)

  question_text = [
    "Education: Program philosophy",
    "Education: Accreditation",
    "Education: Overall curriculum",
    "Education: Rotations/electives",
    "Education: Rounds (educational vs work)",
    "Education: Conferences",
    "Education: Number and variety of patients",
    "Education: Hospital library",
    "Attending Physicians/Teaching Faculty: Number of full-time vs part-time",
    "Attending Physicians/Teaching Faculty: Research vs teaching responsibilities",
    "Attending Physicians/Teaching Faculty: Clinical vs teaching skills",
    "Attending Physicians/Teaching Faculty: Availability/approachability",
    "Attending Physicians/Teaching Faculty: Preceptors in clinic",
    "Attending Physicians/Teaching Faculty: Subspecialties represented",
    "Attending Physicians/Teaching Faculty: Instruction in patient counseling/education",
    "Hospital: Community or university hospital",
    "Hospital: Staff physicians' support of program",
    "Hospital: Availability of consultative services",
    "Hospital: Other residency programs",
    "Hospital: Type(s) of patients",
    "Hospital: Hospital staff (nursing, lab, path, etc.)",
    "Current House Officers: Number per year",
    "Current House Officers: Medical schools of origin",
    "Current House Officers: Personality",
    "Current House Officers: Dependability",
    "Current House Officers: Honesty",
    "Current House Officers: Cooperativeness/get along together",
    "Current House Officers: Compatibility/can I work with them?",
    "Work Load: Average number of pts/HO* (rotation, clinic)",
    "Work Load: Supervision - senior HO, attending staff",
    "Work Load: Call schedule",
    "Work Load: Rounds",
    "Work Load: Teaching/conference responsibility",
    "Work Load: \"Scut\" work",
    "Work Load: Time for conferences",
    "Work Load: Clinic responsibilities",
    "Benefits:
  ]

  question_text.each do |text|
    template.questions.create!(:text => text)
  end
end