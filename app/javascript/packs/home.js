import Vue from 'vue/dist/vue.esm'
import { vue_init } from '../mixins/vue_init.js';
import 'babel-polyfill'

document.addEventListener('DOMContentLoaded', () => {
  const homePageApp = new Vue({
    el: '#home-page-app',
    mixins: [vue_init],
    data: {

    },

    components: {

    },

    mounted() {

    },

    methods: {

    },


  });
});
