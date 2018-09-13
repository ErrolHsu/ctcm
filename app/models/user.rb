class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]


  has_one :cart, dependent: :destroy
  has_many :orders, dependent: :nullify
  has_many :period_orders, dependent: :nullify

  def self.from_facebook(user_profile)
    where(provider: 'facebook', uid: user_profile['id']).first_or_create! do |user|
      user.provider = 'facebook'
      user.uid      = user_profile['id']
      user.email    = user_profile['email']
      user.name     = user_profile['name']
      user.password = Devise.friendly_token[0,20]
      # user.remote_avatar_url = user_profile['image']
    end
  end

  # def self.from_omniauth(auth)
  #   where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
  #     user.provider = auth.provider
  #     user.uid      = auth.uid
  #     user.email    = auth.info.email
  #     user.name     = auth.info.name
  #     user.password = Devise.friendly_token[0,20]
  #     user.remote_avatar_url   = auth.info.image
  #   end
  # end

  # def delete_access_token(auth)
  #   @graph ||= Koala::Facebook::API.new(auth.credentials.token)
  #   @graph.delete_connections(auth.uid, "permissions")
  # end
end
