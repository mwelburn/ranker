class Category < ActiveRecord::Base
  attr_accessible :name, :comment, :position
  before_validation :default_values

  belongs_to :problem
  has_many :questions, :dependent => :destroy

  validates :name, :presence => true,
                   :uniqueness => { :scope => :problem_id }

  validates :position, :numericality => { :greater_than => 0,
                                          :message => "is not a non-negative integer",
                                          :only_integer => true
                                        }
                       :default

  validates :problem_id, :presence => true

  default_scope :order => 'categories.problem_id ASC, categories.position ASC'

  private

    def default_values
      # set position to 1 higher than the highest position of this problem's questions
      self.position = (self.problem.new_category_position) unless self.position
    end
end
