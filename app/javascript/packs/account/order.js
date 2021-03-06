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
        order_no: '',
        status: '',
        payment_status: '',
        payment_name: '',
      },
      currentPeriodOrder: {},
      // 物流追蹤碼
      trackingNo: '',
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

      // init current_period_order data
      const currentPeriodOrderJson = document.getElementById("current-period-order-json");
      const currentPeriodOrderJsonData = JSON.parse(currentPeriodOrderJson.getAttribute('data'));
      this.currentPeriodOrder = Object.assign({}, currentPeriodOrderJsonData);
    },

    computed: {
      isUnpaid() {
        if (this.order.payment_status === 'pending') {
          return true;
        } else {
          return false;
        }
      },

      // 出現烘培中按鈕
      perparingBtnShow() {
        return (this.currentPeriodOrder.paid && this.currentPeriodOrder.shipping_status === 'pending' )
      },

      // 出現配送中按鈕
      shippingBtnShow() {
        return (this.currentPeriodOrder.paid && this.currentPeriodOrder.shipping_status === 'preparing')
      },

      currentPeriodOrderPresent() {
        return object_present(this.currentPeriodOrder);
      },
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

      // 取消訂閱
      cancelSubscribe (orderNo) {
        let self = this;
        EventBus.$emit('loading');
        axios.get(`/account/orders/${orderNo}/cancel_subscribe`)
        .then(response => {
          self.order = Object.assign({}, JSON.parse(response.data.order_json))
          success_msg(response.data.message);
        })
        .catch(err => {
          error_msg(err.response.data.message);
        })
        .then(() => {
          EventBus.$emit('end-loading');
        })
      },

      // 填寫物流追蹤碼表單
      trackingNoModalShow() {
        $('#tracking-no-modal').modal('show');
      },

      // 定期訂單配送狀態改為烘培中
      periodOrderPreparing() {
        let self = this;
        let orderNo = self.order.order_no;
        EventBus.$emit('loading');
        axios.get(`/admin/orders/${orderNo}/period_order_preparing`)
        .then(res => {
          self.currentPeriodOrder = Object.assign({}, JSON.parse(res.data.current_period_order_json))
          success_msg(res.data.message);
        })
        .catch(err => {
          error_msg(err.res.data.message);
        })
        .then(() => {
          EventBus.$emit('end-loading');
        })
      },

      // 定期訂單配送狀態改為配送中
      periodOrderShipping() {
        let self = this;

        if (self.trackingNo.length === 0) {
          error_msg('請填寫物流追蹤碼')
          return
        }

        $('#tracking-no-modal').modal('hide');

        let orderNo = self.order.order_no;
        EventBus.$emit('loading');
        axios.get(`/admin/orders/${orderNo}/period_order_shipping`, {
          params: {
            trackingNo: self.trackingNo
          }
        })
        .then(res => {
          self.currentPeriodOrder = Object.assign({}, JSON.parse(res.data.current_period_order_json))
          success_msg(res.data.message);
        })
        .catch(err => {
          error_msg(err.res.data.message);
        })
        .then(() => {
          EventBus.$emit('end-loading');
        })
      }
    }
  })
})

