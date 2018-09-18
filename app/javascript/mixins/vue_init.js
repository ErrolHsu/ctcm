import axios from 'axios'
import NavbarUserController from '../components/navbar_user_controller.vue'
import PhoneUserController from '../components/phone_user_controller.vue'
import LoginModal from '../components/login_modal.vue'
import Loader from '../components/loader.vue'
import { EventBus } from '../event_bus.js';

const vue_init = {
  data: function() {
    return {
      user_login: false,
      current_user: {},
      // 手機navbar
      phone_options: false,
      about_links: false,
    }
  },

  components: {
    NavbarUserController,
    PhoneUserController,
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
      // TODO 登出後如該頁面非會員不能訪問則導回首頁
    });

    // phone options 關閉
    EventBus.$on('hide-phone-options', () => {
      this.phone_options = false;
    });

  },

  computed: {
    // 手機navbar漢堡條樣式
    barStyle () {
      if (this.phone_options) {
        return 'clicked'
      } else {
        return 'non-clicked'
      }
    },
    // 手機navbar plus icon
    plusStyle () {
      if (this.about_links) {
        return 'clicked'
      } else {
        return 'non-clicked'
      }
    }
  },

  methods: {
    // 手機選單
    showPhoneOptions () {
      this.phone_options = !this.phone_options;
    },

    showAboutLinks () {
      this.about_links = !this.about_links;
    }
  }
}

export { vue_init };
