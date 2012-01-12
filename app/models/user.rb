class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me

  validates :name, :presence => true,
                   :length => { :maximum => 50 }

  has_many :problems, :dependent => :destroy
  has_many :templates, :dependent => :destroy, :class_name => "Problem", :conditions => { :is_template => true }

  default_scope :order => 'users.created_at DESC'
end
