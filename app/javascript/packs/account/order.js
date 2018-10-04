import Vue from 'vue/dist/vue.esm';
import axios from 'axios'
import { vue_init } from '../../mixins/vue_init.js';
import { EventBus } from '../../event_bus.js';

document.addEventListener('DOMContentLoaded', () => {
  const AccountOrderApp = new Vue({
    el: '#account-order-app',
    mixins: [vue_init],
    data: {
      // order
      order: {
        id: '',
        order_no: '',
        status: '',
        payment_status: '',
      },
      // ecpay_info 所需資料
      ecpay_info: {},
    },

    mounted() {
      let url_string = window.location;
      let url = new URL(url_string);
      this.order.order_no = url.pathname.split('/')[3]

      // init order data
      const orderJson = document.getElementById("order-json");
      const orderJsonData = JSON.parse(orderJson.getAttribute('data'));
      this.order = Object.assign({}, orderJsonData);
    },

    computed: {
      },

    methods: {
      // 產生ecpay付款所需資料並跳往綠界
      go_to_pay: function() {
        let self = this;
        EventBus.$emit('loading');
        axios.post('/orders/ecpay_generate', {
          order_no: self.order.order_no
        })
        .then(function(response) {
          self.ecpay_info = Object.assign({}, response['data']['ecpay_info']);
        })
        .then(function(response) {
          document.getElementById('ecpay_info_form').submit();
        })
        .catch(function(error) {
          error_msg(error.response['data']['message']);
        })
      },

      cancelSubscribe (orderId) {
        let self = this;
        EventBus.$emit('loading');
        axios.get(`/account/orders/${orderId}/cancel_subscribe`)
        .then(response => {
          self.order = Object.assign({}, response.data.order_json)
          success_msg(response.data.message);
        })
        .catch(err => {

        })
        .then(() => {
          EventBus.$emit('end-loading');
        })
      },
    }
  })
})

