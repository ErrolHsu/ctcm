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
      // let url_string = window.location;
      // let url = new URL(url_string);
      // self.token = url.searchParams.get('token')
      self.token = self.getParameterByName('token');
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
            // if (self.period_order_set.price >= 1500) {
            //   self.period_order_set.shipping_rate = 0;
            // } else {
            //   self.period_order_set.shipping_rate = 100;
            // }
            // 定期配送運費為 0
            self.period_order_set.shipping_rate = 0;


            self.status = 'step1';
            EventBus.$emit('end-loading');
          })
          .catch(function(error) {
            error_msg(error.response['data']['message']);
            EventBus.$emit('end-loading');
          })
      }

      // 如果有登入直接幫顧客帶入email
      self.shipping_info.email = self.current_user.email;
    },

    computed: {
      order_total_cost () {
        return (this.period_order_set.price + this.period_order_set.shipping_rate)
      },

      // 檢查是否有收件地址
      check_shipping_info () {
        let shipping_info = this.shipping_info;
        return (
          shipping_info.name === '' || shipping_info.email === '' || shipping_info.phone === '' || shipping_info.address === ''
        )
      }
    },

    methods: {
      // check step
      checkCurrentStatus (status) {
        return status === this.status;
      },

      got_to_step3 () {
        if (this.check_shipping_info) {
          error_msg('請確實填寫收件資訊');
          return;
        }

        // 驗證email
        if (this.validateEmail(this.shipping_info.email)) {
          this.status = 'step3';
        } else {
          error_msg('email格式錯誤');
        }
      },

      validateEmail (email) {
        let re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        return re.test(String(email).toLowerCase());
      },

      // 建立訂單
      create_period_order () {
        let self = this;

        // check 收件地址
        if (self.check_shipping_info) {
          error_msg('請確實填寫收件資訊')
          return
        }
        // check 付款方式
        if (self.payment_type.length === 0) {
          error_msg('請選擇付款方式')
          return
        }

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
        EventBus.$emit('loading');
        axios.post('/orders/ecpay_generate', {
          order_no: self.order_no
        })
        .then(function(response) {
          self.ecpay_info = Object.assign({}, response['data']['ecpay_info']);
        })
        .then(function(response) {
          // 手機上表單不會馬上render出來
          // 如果input 沒出來，等一秒再送
          if (document.getElementsByName("MerchantTradeNo").length === 1) {
            document.getElementById('ecpay_info_form').submit();
            EventBus.$emit('end-loading');
          } else {
            setTimeout(() => {
              EventBus.$emit('end-loading');
              document.getElementById('ecpay_info_form').submit();
            }, 1000)
          }
        })
        .catch(function(error) {
          error_msg(error.response['data']['message']);
          EventBus.$emit('end-loading');
        })
      },

    }

  });
});
