module EcpayServices

  class Payment < EcpayServices::Ecpay
    include Settings

    def initialize
      @order = Order.new(total: 1000, order_no: '180630210019CTCM5DF6')
      @item  = OrderItem.new(product_name: '黃金咖啡豆 500g')

    end


  end

end
