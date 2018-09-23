import Vue from 'vue/dist/vue.esm';
import axios from 'axios'
import { vue_init } from '../mixins/vue_init.js';

document.addEventListener('DOMContentLoaded', () => {
  const homePageApp = new Vue({
    el: '#home-page-app',
    mixins: [vue_init],
    data: {
      //定期訂購Products
      period_order_products: [],
      current_product: {},
      current_variant: {},
      // 定期訂購表單控制
      period_order_form: false,
      // 定期訂購表單data
      order_set: {
        product: {},
        variant: {},
        frequency: 0,
        duration: 0
      }
    },

    components: {

    },

    mounted() {
      let self = this;
      // 初始化定期配送Product
      axios.get('/find_period_order_products')
        .then(function(response) {
          console.log(response['data']['period_order_products'])
          self.period_order_products = response['data']['period_order_products'];
        })
        .catch(function(error) {
          error_msg(error.response['data']['message'])
        })
    },

    computed: {
      order_set_product_present () {
        return object_present(this.order_set.product);
      }
    },

    methods: {
      // 顯示定期訂購表單
      showPeriodOrderForm () {
        this.period_order_form = true;
        setTimeout(() => {
          window.location.href = '#period-order';
        }, 100)
      },

      set_order_product (product) {
        this.order_set.product = product;
        this.order_set.variant = {};
      },

      set_order_variant (variant) {
        this.order_set.variant = variant;
      },



      /////////////////
      selectKind (kind) {
        this.order_set.kind = kind;
      },

      selectWeight (weight) {
        this.order_set.weight = weight;
      },

      selectFrequency (frequency) {
        this.order_set.frequency = frequency;
      },

      selectDuration (duration) {
        this.order_set.duration = duration;
      },

      // 判斷是否被選中
      checkSeleted (current_value, value) {
        if (current_value === value) {
          return 'seleted'
        }
      },

      // 前往結帳
      goToCheckout () {
        let self = this;
        let token;
        // 結帳前須登入
        if ( !object_present(this.current_user) ) {
          error_msg('結帳前請先登入')
          return
        }
        // TODO 檢查 order_set
        if (!this.checkOrderSet()) {
          error_msg('有未選擇的項目')
          return
        }

        axios.post('checkout/jwt_encode', {
          order_set: self.order_set
        })
          .then(function(response) {
            console.log(response['data']['token']);
            token = response['data']['token'];
            let url = `/checkout?token=${token}`
            window.location = url;
          })
          .catch(function(error) {
            error_msg(error.response['data']['message']);
          })
      },

      checkOrderSet () {
        return (
          object_present(this.order_set.product) &&
          object_present(this.order_set.variant) &&
          this.order_set.frequency &&
          this.order_set.duration
        )
      },

    },


  });
});
