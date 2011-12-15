class Problem < ActiveRecord::Base
  attr_accessible :name, :comment

  belongs_to :user
  has_many :solutions, :dependent => :destroy
  has_many :questions, :dependent => :destroy

  validates :name, :presence => true,
                  :length => { :maximum => 75 }
  validates :user_id, :presence => true

  default_scope :order => 'problems.created_at DESC'
end
