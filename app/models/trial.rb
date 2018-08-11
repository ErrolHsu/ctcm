class Trial < ApplicationRecord

  scope :undone, -> { where( executed: false ) }
  scope :shipped, -> { where( status: 'shipped' ) }
  scope :be_reject, -> { where( status: 'reject' ) }

  def translate
    self.status = Reference::TrialStatus.find_by(code: self.status).try(:[], :name)
    self.status ||= 'undefined'
    self.product_name = '無指定' if self.product_name.blank?
    self
  end

end
