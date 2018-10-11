class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable, :validatable

  has_one :setting, class_name: 'AdminSetting', dependent: :destroy

  after_create :init_setting

  private

  def init_setting
    self.create_setting
  end
end
