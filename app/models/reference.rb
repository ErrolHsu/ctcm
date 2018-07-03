# encoding: utf-8
module Reference
  class Base < ActiveHash::Base

    def self.to_hash
      all.map { |e| {id: e.id, name: e.name, value: e.value} }
    end

  end

  class OrderStatus < Reference::Base
    self.data = [
      {id: 1, name: '已下單', value: 'open' },
      {id: 2, name: '待處理', value: 'pending'},
      {id: 3, name: '進行中', value: 'process'}, # 定期訂單
      {id: 4, name: '已結案', value: 'close'},
      {id: 5, name: '異常',   value: 'error'},
    ]
  end

  class PaymentStatus < Reference::Base
    self.data = [
      {id: 1, name: '待付款', value: 'pending' },
      {id: 2, name: '已取號', value: 'take'},
      {id: 3, name: '訂閱中', value: 'subscribe'},
      {id: 4, name: '已付款', value: 'paid'},
      {id: 5, name: '異常',   value: 'error'},
    ]
  end

  class ShippingStatus < Reference::Base
    self.data = [
      {id: 1, name: '收到訂單',  value: '' },
      {id: 2, name: '烘培中',    value: '' },
      {id: 3, name: '已寄送',    value: ''},
      {id: 4, name: '已到店',    value: ''},
      {id: 5, name: '已取貨',    value: ''},
      {id: 6, name: '定期配送',  value: ''},
      {id: 7, name: '異常',      value: 'error'},
    ]
  end

  class Period < Reference::Base
    self.data = [
      {id: 1, name: '每週', value: 7 },
      {id: 2, name: '隔週', value: 14 },
      {id: 3, name: '三週', value: 21 },
      {id: 4, name: '每月', value: 30 },
    ]
  end

  class Limit < Reference::Base
    self.data = [
      {id: 1, name: '三個月', value: 90},
      {id: 2, name: '六個月', value: 180},
      {id: 3, name: '九個月', value: 270},
      {id: 4, name: '十二個月', value: 360},
    ]
  end

end
