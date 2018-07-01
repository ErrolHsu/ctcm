const order_show_app = new Vue({
  el: '#order_show_app',
  data: {
    order: {},
    merchant_trade_no: '',
  },

  methods: {
    go_to_pay: function(event) {
      let self = this;
      let order_id = event.target.getAttribute('data-order-id');
      axios.post('/orders/ecpay_generate', {
        order_id: order_id
      })
      .then(function(response) {
        self.order = Object.assign({}, response['data']['order']);
      })
      .then(function(response) {
        document.getElementById('order_form').submit();
      })
      .catch(function(error) {
        error_msg(error.response['data']['message']);
      })

    },
  }
})
