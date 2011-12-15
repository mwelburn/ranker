class Question < ActiveRecord::Base
  attr_accessible :text, :weight, :position
  before_save :default_values

  belongs_to :problem
  has_many :answers, :dependent => :destroy

  validates :text, :presence => true
  # TODO - should we allow duplicate positions (then we'd have to :before_save fix that)
  validates :position, :numericality => { :greater_than_or_equal_to => 0,
                                          :message => "is not a non-negative integer",
                                          :only_integer => true
                                        }
  validates :weight, :numericality => { :greater_than => 0,
                                        :less_than => 6,
                                        :message => "is not an integer between 1 and 5",
                                        :only_integer => true
                                      }
  validates :problem_id, :presence => true

  default_scope :order => 'questions.position ASC'

  private

    def default_values
      self.weight = 1 unless self.weight
    end
end