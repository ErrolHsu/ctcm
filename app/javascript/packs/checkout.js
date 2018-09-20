import Vue from 'vue/dist/vue.esm';
import { vue_init } from '../mixins/vue_init.js';

document.addEventListener('DOMContentLoaded', () => {
  const checkOutApp = new Vue({
    el: '#check-out-app',
    mixins: [vue_init],
    data: {
      period_order_set: {
        kind: '',
        weight: 0,
        frequency: 0,
        duration: 0
      }
    },

    components: {

    },

    mounted() {
      let url_string = window.location;
      let url = new URL(url_string);
      this.period_order_set.kind = url.searchParams.get('kind');
      this.period_order_set.weight = url.searchParams.get('weight');
      this.period_order_set.frequency = url.searchParams.get('frequency');
      this.period_order_set.duration = url.searchParams.get('duration');
    },

    methods: {

    }

  });
});
