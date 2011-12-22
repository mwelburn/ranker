class Answer < ActiveRecord::Base
  attr_accessible :rating, :comment, :question_id

  belongs_to :solution
  belongs_to :question

  validates :rating, :numericality => { :greater_than => 0,
                                        :less_than => 6,
                                        :message => "is not an integer between 1 and 5",
                                        :only_integer => true
                                      },
                     :allow_nil => true
  validates :question_id, :presence => true
  validates :solution_id, :presence => true

  default_scope :order => 'answers.created_at ASC'

end
