import { EventBus } from '../event_bus.js';
const user_controller = {
  data: function() {
    return {
      user_login: false,
      current_user: {},
    }
  },

  mounted() {
    // 會員登入
    console.log('123')
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

export { user_controller };
