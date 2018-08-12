class TrialMailer < ApplicationMailer

  def notify_shipped(trial)
    @trial = trial
    mail(to: @trial.email , subject: "您的試用包已經寄出")
  end

end
