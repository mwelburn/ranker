class Solution < ActiveRecord::Base
  attr_accessible :name, :comment

  belongs_to :problem
  has_many :answers, :dependent => :destroy

  validates :name, :presence => true,
                   :length => { :maximum => 75 }
  validates :problem_id, :presence => true

  #TODO - can I implement this using the ranking method?
  #default_scope :order => 'solutions.ranking DESC'
#  default_scope order("ranking DESC")

  def ranking
    questions = self.problem.questions

    if !questions.empty?
      if questions.length > self.answers.length
        # Not all questions have been answered
        "INC"
      elsif self.answers.find_by_rating(nil)
        # Not all questions have been answered
        "INC"
      else
        temp_ranking = 0
        self.answers.each do |answer|
          temp_ranking += answer.question.weight * answer.rating
        end
        temp_ranking
      end
    else
      0
    end
  end

  def order(*args)
    return self if args.blank?

    relation = clone
    relation.order_values += args.flatten
    relation
  end

end
