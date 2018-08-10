class Trial < ApplicationRecord

  def translate
    self.status = Reference::TrialStatus.find_by(code: self.status)[:name]
    self.product_name = '無指定' if self.product_name.blank?
    self
  end




end
