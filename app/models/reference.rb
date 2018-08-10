# encoding: utf-8
module Reference
  class Base < ActiveHash::Base

    def self.to_hash
      all.map { |e| {id: e.id, name: e.name, code: e.code} }
    end

  end

  class OrderStatus < Reference::Base
    self.data = [
      {id: 1, name: '已下單', code: 'open' },
      {id: 2, name: '待處理', code: 'pending'},
      {id: 3, name: '進行中', code: 'process'}, # 定期訂單
      {id: 4, name: '已結案', code: 'close'},
      {id: 5, name: '異常',   code: 'error'},
    ]
  end

  class PaymentStatus < Reference::Base
    self.data = [
      {id: 1, name: '待付款', code: 'pending' },
      {id: 2, name: '已取號', code: 'take'},
      {id: 3, name: '訂閱中', code: 'subscribe'},
      {id: 4, name: '已付款', code: 'paid'},
      {id: 5, name: '異常',   code: 'error'},
    ]
  end

  class ShippingStatus < Reference::Base
    self.data = [
      {id: 1, name: '收到訂單',  code: '' },
      {id: 2, name: '烘培中',    code: '' },
      {id: 3, name: '已寄送',    code: ''},
      {id: 4, name: '已到店',    code: ''},
      {id: 5, name: '已取貨',    code: ''},
      {id: 6, name: '定期配送',  code: ''},
      {id: 7, name: '異常',      code: 'error'},
    ]
  end

  class TrialStatus < Reference::Base
    self.data = [
      {id: 1, name: '申請試用', code: 'request' },
      {id: 2, name: '已寄出',   code: 'shipped'},
      {id: 3, name: '拒絕',     code: 'reject'},
    ]
  end

  class Period < Reference::Base
    self.data = [
      {id: 1, name: '每週', code: 7 },
      {id: 2, name: '隔週', code: 14 },
      {id: 3, name: '三週', code: 21 },
      {id: 4, name: '每月', code: 30 },
    ]
  end

  class Limit < Reference::Base
    self.data = [
      {id: 1, name: '三個月', code: 90},
      {id: 2, name: '六個月', code: 180},
      {id: 3, name: '九個月', code: 270},
      {id: 4, name: '十二個月', code: 360},
    ]
  end

end
