// const OrderShowApp = new Vue({
//   el: '#order_show_app',
//   data: {
//     ecpay_info: {},
//     merchant_trade_no: '',
//   },

//   methods: {
//     go_to_pay: function(event) {
//       let self = this;
//       let order_id = event.target.getAttribute('data-order-id');
//       axios.post('/orders/ecpay_generate', {
//         order_id: order_id
//       })
//       .then(function(response) {
//         self.ecpay_info = Object.assign({}, response['data']['ecpay_info']);
//       })
//       .then(function(response) {
//         document.getElementById('ecpay_info_form').submit();
//       })
//       .catch(function(error) {
//         error_msg(error.response['data']['message']);
//       })

//     },
//   }
// })
