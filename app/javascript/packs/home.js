import Vue from 'vue/dist/vue.esm';
import { vue_init } from '../mixins/vue_init.js';

document.addEventListener('DOMContentLoaded', () => {
  const homePageApp = new Vue({
    el: '#home-page-app',
    mixins: [vue_init],
    data: {
      period_order_form: false,
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
    },


  });
});
