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
      currentPeriodOrder: {

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
      }
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
    }
  })
})

