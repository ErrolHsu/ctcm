import Vue from 'vue/dist/vue.esm';
import { vue_init } from '../mixins/vue_init.js';

document.addEventListener('DOMContentLoaded', () => {
  const homePageApp = new Vue({
    el: '#home-page-app',
    mixins: [vue_init],
    data: {
      period_order_form: true,

      // 定期訂購表單data
      order_set: {
        kind: '',
        weight: 0,
        frequency: 0,
        duration: 0
      }
    },

    components: {

    },

    mounted() {

    },

    methods: {
      // 顯示定期訂購表單
      showPeriodOrderForm () {
        this.period_order_form = true;
        setTimeout(() => {
          window.location.href = '#period-order';
        }, 100)
      },

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
        let kind = this.order_set.kind;
        let weight = this.order_set.weight;
        let frequency = this.order_set.frequency;
        let duration = this.order_set.duration;

        let url = `/checkout?kind=${kind}&weight=${weight}&frequency=${frequency}&duration=${duration}`

        window.location = url;
      },

      checkOrderSet () {
        return (
          this.order_set.kind && this.order_set.weight && this.order_set.frequency && this.order_set.duration
        )
      },

    },


  });
});
