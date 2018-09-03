import axios from 'axios'
import NavbarUserController from '../components/navbar_user_controller.vue'
import LoginModal from '../components/login_modal.vue'
import Loader from '../components/loader.vue'
import { EventBus } from '../event_bus.js';

const vue_init = {
  data: function() {
    return {
      user_login: false,
      current_user: {},
    }
  },

  components: {
    NavbarUserController,
    LoginModal,
    Loader,
  },

  mounted() {
    // set CSRF Token
    const csrf_token = document.querySelector("meta[name=csrf-token]").content;
    axios.defaults.headers.common['X-CSRF-Token'] = csrf_token;
    axios.defaults.headers.common['Accept'] = 'application/json'

    // init data
    const element = document.getElementById("props");
    const props = JSON.parse(element.getAttribute('data'));
    this.user_login = props.user_login;
    this.current_user = props.current_user;

    // 會員登入
    EventBus.$on('login-user', (current_user) => {
      this.user_login = true;
      this.current_user = current_user;
    });

    // 會員登出
    EventBus.$on('sign-out-user', () => {
      this.user_login = false;
      this.current_user = {};
    })
  },
}

export { vue_init };
