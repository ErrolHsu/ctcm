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
      this.redirectToRoot();
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
    },

    // 拿到query string值
    getParameterByName (name, url) {
      if (!url) url = window.location.href;
      name = name.replace(/[\[\]]/g, '\\$&');
      var regex = new RegExp('[?&]' + name + '(=([^&#]*)|&|#|$)'),
          results = regex.exec(url);
      if (!results) return null;
      if (!results[2]) return '';
      return decodeURIComponent(results[2].replace(/\+/g, ' '));
    },

    // 登出後如果是在會員中心，則導回首頁
    redirectToRoot () {
      let url_string = window.location;
      let url = new URL(url_string);
      if (url.pathname.split('/')[1] == 'account') {
        window.location = '/';
      }
    },
  }
}

export { vue_init };
