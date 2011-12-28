class Solution < ActiveRecord::Base

  attr_accessible :name, :comment

  belongs_to :problem
  has_many :answers, :dependent => :destroy
  accepts_nested_attributes_for :answers, :allow_destroy => true

  validates :name, :presence => true,
                   :length => { :maximum => 75 },
                   :uniqueness => { :scope => :problem_id }
  validates :problem_id, :presence => true

  default_scope :order => 'solutions.completed DESC, solutions.answer_total DESC'

  def update_answer_total
    #When the rating is nil, it will convert to the integer zero
    self.answer_total = self.answers.collect{ |i| i.rating.to_i * i.question.weight.to_i }.sum
    self.save!
  end

  def validate_solution
    if self.problem.questions.length > answers.length
      self.completed = false
    elsif answers.find_by_rating(nil)
      self.completed = false
    else
      self.completed = true
    end
    self.save!
  end

  def match_decimal
    questions = self.problem.questions
    0 if questions.empty?

    if questions.length > self.answers.length
      # Not all questions have been answered
      -1
    elsif self.answers.find_by_rating(nil)
      # Not all questions have been answered
      -1
    else
      self.answer_total.to_f / self.problem.question_total
    end
  end
end
