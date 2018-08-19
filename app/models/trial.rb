class Trial < ApplicationRecord
  default_scope { order(created_at: :asc) }

  scope :undone, -> { where( executed: false ) }
  scope :shipped, -> { where( status: 'shipped' ) }
  scope :be_reject, -> { where( status: 'reject' ) }

  def translate
    self.status = Reference::TrialStatus.find_by(code: self.status).try(:[], :name)
    self.status ||= 'undefined'
    self.product_name = '無指定' if self.product_name.blank?
    self
  end

  def shipping
    MailServices::TrialMailer.shipped(self)
    self.status = 'shipped'
    self.executed = true
    self.save
  end

  def request_reject
    MailServices::TrialMailer.reject(self)
    self.status = 'reject'
    self.executed = true
    self.save
  end

  def reset
    self.status = 'request'
    self.executed = false
    self.save
  end

end
