import Vue from 'vue/dist/vue.esm';
import axios from 'axios'
import { markDown } from '../../mixins/markDown.js';

document.addEventListener('DOMContentLoaded', () => {
  const NewProductApp = new Vue({
    el: '#new_product_app',
    mixins: [markDown],
    data: {
      variants: [{
        weight: '',
        price: '',
        quantity: '',
      }]
    },

    mounted() {
      // set CSRF Token
      const csrf_token = document.querySelector("meta[name=csrf-token]").content;
      axios.defaults.headers.common['X-CSRF-Token'] = csrf_token;
      axios.defaults.headers.common['Accept'] = 'application/json';
    },

    computed: {
      variants_json: function() {
        return JSON.stringify(this.variants);
      }
    },

    methods: {
      add_variant_input: function() {
        this.variants.push({weight: '', price: '', quantity: ''});
      },

      remove_variant_input: function(index) {
        this.variants.splice(index, 1);
      },
    }
  })
})

