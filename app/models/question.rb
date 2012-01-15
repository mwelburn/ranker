class Question < ActiveRecord::Base
  attr_accessible :text, :weight, :position, :category_id
  before_validation :default_values

  belongs_to :problem
  belongs_to :category
  has_many :answers, :dependent => :destroy

  validates :text, :presence => true,
                   :uniqueness => { :scope => :problem_id }
  # TODO - should we allow duplicate positions (then we'd have to :before_save fix that)
  validates :position, :numericality => { :greater_than => 0,
                                          :message => "is not a non-negative integer",
                                          :only_integer => true
                                        }
                       :default 
  validates :weight, :numericality => { :greater_than => 0,
                                        :less_than => 6,
                                        :message => "is not an integer between 1 and 5",
                                        :only_integer => true
                                      }
  validates :problem_id, :presence => true

  default_scope :order => 'questions.problem_id ASC, questions.category_id ASC, questions.position ASC'

  private

    def default_values
      self.weight = 1 unless self.weight
      # set position to 1 higher than the highest position of this problem's questions
      self.position = (self.problem.new_question_position) unless self.position
    end
end