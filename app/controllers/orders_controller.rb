class OrdersController < ApplicationController

  expose :period_orders, -> { current_user.period_orders }

  def index

  end

  def create
    order = current_user.orders.create(
      total: 1200,
      regular: true,
      period_type: 'month',
      frequency: 1,
      exec_times: 12,
    )

    date = Date.today

    12.times do |i|
      order.period_orders.create(
        user_id: current_user.id,
        no: i,
        amount: 100,
        expected_date: date + (i - 1).month,
        paid: false,
      )
    end

    redirect_to orders_path

  end

end
