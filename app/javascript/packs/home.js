import Vue from 'vue/dist/vue.esm';
import { vue_init } from '../mixins/vue_init.js';

document.addEventListener('DOMContentLoaded', () => {
  const homePageApp = new Vue({
    el: '#home-page-app',
    mixins: [vue_init],
    data: {
      period_order_form: true,
    },

    components: {

    },

    mounted() {

    },

    methods: {
      showPeriodOrderForm () {
        this.period_order_form = true;
        setTimeout(() => {
          window.location.href = '#period-order';
        }, 100)
      },

      // 前往結帳
      goToCheckout () {
        if ( !object_present(this.current_user) ) {
          error_msg('結帳前請先登入')
        } else {
          window.location = '/checkout?a=abc'
        }
      },
    },


  });
});
