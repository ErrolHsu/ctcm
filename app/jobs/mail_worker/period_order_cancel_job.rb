class MailWorker::PeriodOrderCancelJob < ApplicationJob
  queue_as :mailers

  def perform(order_id)
    order = Order.find_by(id: order_id)
    MailServices::OrderMailer.period_order_cancel(order)
  end
end
