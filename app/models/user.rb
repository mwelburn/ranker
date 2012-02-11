class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  # Setup accessible (or protected) attributes for your model
  #TODO - should facebook_id be modifiable at all after initial creation?
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :facebook_id

  validates :name, :presence => true,
                   :length => { :maximum => 50 }

  has_many :problems, :dependent => :destroy
  has_many :templates, :dependent => :destroy, :class_name => "Problem", :conditions => { :is_template => true }

  default_scope :order => 'users.created_at DESC'

  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token.extra.raw_info
    if user = User.where(:facebook_id => data.id).first
      #TODO - update the email/name if they have changed. need to verify that there isn't an existing email being used
      user
    else # Create a user with a stub password.
      User.create!(:email => data.email, :name => data.name, :facebook_id => data.id, :password => Devise.friendly_token[0,20])
    end
  end

  #sample code to grab information
  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"]
      end
    end
  end

end
