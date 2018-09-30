import Vue from 'vue/dist/vue.esm';
import axios from 'axios'
import { vue_init } from '../../mixins/vue_init.js';
import { EventBus } from '../../event_bus.js';

document.addEventListener('DOMContentLoaded', () => {
  const AccountOrderApp = new Vue({
    el: '#account-order-app',
    mixins: [vue_init],
    data: {
      // 訂單編號
      order_no: '',
      // ecpay_info 所需資料
      ecpay_info: {},
    },

    mounted() {
      let url_string = window.location;
      let url = new URL(url_string);
      this.order_no = url.pathname.split('/')[3]
    },

    computed: {
      },

    methods: {
      // 產生ecpay付款所需資料並跳往綠界
      go_to_pay: function() {
        let self = this;
        EventBus.$emit('loading');
        axios.post('/orders/ecpay_generate', {
          order_no: self.order_no
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
    }
  })
})

