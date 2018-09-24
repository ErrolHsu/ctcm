import Vue from 'vue/dist/vue.esm';
import { vue_init } from '../mixins/vue_init.js';
import axios from 'axios'
import { EventBus } from '../event_bus.js';

document.addEventListener('DOMContentLoaded', () => {
  const checkOutApp = new Vue({
    el: '#check-out-app',
    mixins: [vue_init],
    data: {
      status: '',
      // 紀錄product資訊的token
      token: '',
      // 定期訂單配置
      period_order_set: {
        product: {},
        variant: {},
        frequency: 0,
        duration: 0,
        price: 0,
        shipping_rate: 0,
      },
      // 配送資料
      shipping_info: {
        name: '',
        phone: '',
        email: '',
        address: ''
      },
      // 訂單成立後的訂單編號
      order_no: '',
      // ecpay_info 所需資料
      ecpay_info: {},
      // 選擇的付款方式
      payment_type: '',
    },

    components: {

    },

    mounted() {
      let self = this;
      let url_string = window.location;
      let url = new URL(url_string);
      self.token = url.searchParams.get('token')
      // 有token代表是定期訂單
      if (self.token) {
        EventBus.$emit('loading');
        axios.post('checkout/jwt_decode', {
            token: self.token
          })
          .then(function(response) {
            //  set 定期訂單 data
            let token_payload = JSON.parse(response['data']['token_payload_json']);
            self.period_order_set.product   = token_payload.product;
            self.period_order_set.variant   = token_payload.variant;
            self.period_order_set.frequency = token_payload.frequency;
            self.period_order_set.duration  = token_payload.duration;
            self.period_order_set.price     = token_payload.variant.price;

            // set 運費
            if (self.period_order_set.price >= 1500) {
              self.period_order_set.shipping_rate = 0;
            } else {
              self.period_order_set.shipping_rate = 100;
            }

            self.status = 'step1';
            EventBus.$emit('end-loading');
          })
          .catch(function(error) {
            error_msg(error.response['data']['message']);
            EventBus.$emit('end-loading');
          })
      }
    },

    computed: {
      order_total_cost () {
        return (this.period_order_set.price + this.period_order_set.shipping_rate)
      }
    },

    methods: {
      // check step
      checkCurrentStatus (status) {
        return status === this.status;
      },

      // 建立訂單
      create_period_order () {
        let self = this;
        EventBus.$emit('loading');
        let period_order_total_data = {
          period_order_set: this.period_order_set,
          shipping_info: this.shipping_info,
          payment: 'credit',
          token: this.token,
        }

        axios.post('/orders/create_period_order', {
            period_order_total_data: period_order_total_data
          })
          .then(function(response) {
            self.order_no = response['data']['order_no']
            success_msg(response['data']['message'])
            EventBus.$emit('end-loading');
          })
          .catch(function(error) {
            error_msg(error.response['data']['message'])
            EventBus.$emit('end-loading');
          })

      },

      // 產生ecpay付款所需資料並跳往綠界
      go_to_pay: function() {
        let self = this;
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

  });
});
