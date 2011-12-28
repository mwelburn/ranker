class Problem < ActiveRecord::Base
  attr_accessible :name, :comment

  belongs_to :user
  has_many :solutions, :dependent => :destroy
  has_many :questions, :dependent => :destroy

  validates :name, :presence => true,
                  :length => { :maximum => 75 },
                  :uniqueness => { :scope => :user_id }
  validates :user_id, :presence => true

  default_scope :order => 'problems.created_at DESC'

  def highest_question_position
    -1 unless self.questions

    pos = 0
    self.questions.each do |q|
      if q.position > pos
        pos = q.position
      end
    end
    pos
  end

  def invalidate_solutions
    self.solutions.each do |solution|
      solution.completed = false
      solution.save
    end
  end

  def update_question_total
    self.question_total = self.questions.collect{ |i| i.weight.to_i * 5 }.sum
    self.save!
  end

end
