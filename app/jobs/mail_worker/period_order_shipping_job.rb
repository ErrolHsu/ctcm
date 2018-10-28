class MailWorker::PeriodOrderShippingJob < ApplicationJob
  queue_as :mailers

  def perform(order_id)
    order = Order.find_by(id: order_id)
    MailServices::OrderMailer.period_order_shipping(order)
  end
end
