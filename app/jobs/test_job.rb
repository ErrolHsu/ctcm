class TestJob < ApplicationJob
  queue_as :mailers

  def perform
    MailServices::Mailer.test
  end
end
