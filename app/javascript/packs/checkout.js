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
      // 定期訂單配置
      period_order_set: {
        kind: '',
        weight: 0,
        frequency: 0,
        duration: 0
      },
      // 配送資料
      shipping_info: {
        name: '',
        phone: '',
        email: '',
        address: ''
      }
    },

    components: {

    },

    mounted() {
      let self = this;
      let url_string = window.location;
      let url = new URL(url_string);
      let token = url.searchParams.get('token')
      if (token) {
        EventBus.$emit('loading');
        axios.post('checkout/jwt_decode', {
            token: token
          })
          .then(function(response) {
            console.log(response['data']['token_payload_json'])
            let token_payload = JSON.parse(response['data']['token_payload_json']);
            self.period_order_set.kind = token_payload.kind;
            self.period_order_set.weight = token_payload.weight;
            self.period_order_set.frequency = token_payload.frequency;
            self.period_order_set.duration = token_payload.duration;

            self.status = 'step1';
            EventBus.$emit('end-loading');
          })
          .catch(function(error) {
            error_msg(error.response['data']['message']);
            EventBus.$emit('end-loading');
          })
      }
    },

    methods: {
      checkCurrentStatus (status) {
        return status === this.status;
      }
    }

  });
});
