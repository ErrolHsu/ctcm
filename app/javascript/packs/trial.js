import Vue from 'vue/dist/vue.esm'
import axios from 'axios'

document.addEventListener('DOMContentLoaded', () => {
  const TrialApp = new Vue({
    el: '#trial_app',
    data: {
      trial: {
        name: '',
        email: '',
        phone: '',
        address: '',
        product_name: '',
      }
    },

    mounted() {
      let self = this
      // set CSRF Token
      const csrf_token = document.querySelector("meta[name=csrf-token]").content;
      axios.defaults.headers.common['X-CSRF-Token'] = csrf_token;
      //////////
      axios.defaults.headers.common['Accept'] = 'application/json'
    },

    methods: {
      selectTrialProduct: function(product_name) {
        this.trial.product_name = product_name;
      },

      trialRequest: function() {
        let self = this;
        axios.post('/home/trial_request', {
          trial_info: {
            name: self.trial.name,
            phone: self.trial.phone,
            address: self.trial.address,
            email: self.trial.email,
            message: self.trial.message,
            product_name: self.trial.product_name,
          }
        })
        .then(function(response) {
          success_msg(response['data']['message']);
          self.clearTrialInput();
        })
        .catch(function(error) {
          error_msg(error.response['data']['message']);
        })
      },

      clearTrialInput: function() {
        this.trial = {
          name: '',
          email: '',
          phone: '',
          address: '',
          message: '',
          product_name: '',
        }
      },

      // 是否被選取
      selectedCheck: function(prop, str) {
        if (str === prop) {
          return "seleted";
        }
      },
    }
  })
})

