class Problem < ActiveRecord::Base
  attr_accessible :name, :comment

  belongs_to :user
  has_many :solutions, :dependent => :destroy
  has_many :questions, :dependent => :destroy

  accepts_nested_attributes_for :questions,
                                :allow_destroy => true

  validates :name, :presence => true,
                  :length => { :maximum => 75 },
                  :uniqueness => { :scope => :user_id }
  validates :user_id, :presence => true

  default_scope :order => 'problems.created_at DESC'

  def question_potential
    self.question_total * 5
  end

  def new_question_position
    1 unless self.questions

    pos = 0
    self.questions.each do |q|
      if q.position > pos
        pos = q.position
      end
    end
    pos + 1
  end

  def invalidate_solutions
    self.solutions.each do |solution|
      solution.completed = false
      solution.save!
    end
  end

  def update_question_total
    self.question_total = self.questions.collect{ |i| i.weight.to_i }.sum
    self.save!
  end

  def update_solutions
    unless self.solutions.blank?
      self.solutions.each do |solution|
        solution.update_answer_total
        solution.validate_solution
      end
    end
  end

  def update_questions(questions)
    errors = {}
    questions.each do |question_id, question_attrs|
      question = self.questions.find_by_id(question_id)
      if question.blank?
        #TODO - how will we validate this and return error messages accordingly?
        self.questions.create!(question_attrs)
      else
        unless question.update_attributes(question_attrs)
          errors[question_id] = question.errors
        end
      end
    end
    errors
  end

end
