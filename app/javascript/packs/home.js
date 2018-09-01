import Vue from 'vue/dist/vue.esm'
import NavbarUserController from '../components/navbar_user_controller.vue'
import LoginModal from '../components/login_modal.vue'
import axios from 'axios'
import { EventBus } from '../event_bus.js';

document.addEventListener('DOMContentLoaded', () => {
  const homePageApp = new Vue({
    el: '#home-page-app',
    data: {

    },

    components: {
      NavbarUserController,
      LoginModal
    },

    methods: {

    }
  });
});
