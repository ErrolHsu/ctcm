# encoding: utf-8
module Setting
  class Base < ActiveHash::Base


  end

  class OrderStatus < Setting::Base
    self.data = [
      {id: 1, name: '已下單', code: 'open' },
      {id: 2, name: '待處理', code: 'pending'},
      {id: 3, name: '異常',   code: 'error'},
      {id: 4, name: '已結案', code: 'close'},
    ]
  end
end
