<template>

  <div>
    <!-- 遮罩 -->
    <div class='mask' v-show='display' v-on:click.stop='hideLoginModal'>
    </div>

    <!-- login & register modal -->
    <transition name='opacity'>
      <div class='login-register-modal' v-show='display'>
        <!-- 註冊表單 -->
        <div>
          <div>
            <input v-model='email'>
          </div>
          <div>
            <input v-model='password'>
          </div>
          <div class='btn btn-normal' v-on:click='register'>註冊</div>
        </div>

        <hr>

        <!-- 登入表單 -->
        <div>
          <div>
            <input v-model='login_email'>
          </div>
          <div>
            <input v-model='login_password'>
          </div>
          <div class='btn btn-normal' v-on:click='login'>登入</div>
        </div>

      </div>
    </transition>

  </div>

</template>

<script>

  import { EventBus } from '../event_bus.js';
  import axios from 'axios';

  export default {
    data: function () {
      return {
        display: false,
        // 註冊
        email: '',
        password: '',
        // 登入
        login_email: '',
        login_password: '',
      }
    },

    mounted() {

      EventBus.$on('show-login-modal', () => {
        this.display = true;
      });

      EventBus.$on('hide-login-modal', () => {
        this.display = false;
      });
    },

    methods: {
      hideLoginModal: function() {
        EventBus.$emit('hide-login-modal');
      },

      // 註冊
      register: function() {
        let self = this;
        EventBus.$emit('loading');
        axios.post('/user_sign_up', {
          email: self.email,
          password: self.password,
        })
        .then(response => {
          let current_user = response['data']['current_user'];
          EventBus.$emit('hide-login-modal');
          EventBus.$emit('login-user', current_user);
          success_msg('註冊成功');
          self.reset_form();
          EventBus.$emit('end-loading');
        })
        .catch(error => {
          error_msg(error.response['data']['message']);
          EventBus.$emit('end-loading');
        })
      },

      // 登入
      login: function() {
        let self = this;
        EventBus.$emit('loading');
        axios.post('/user_login', {
          email: self.login_email,
          password: self.login_password,
        })
        .then(response => {
          let current_user = response['data']['current_user'];
          EventBus.$emit('hide-login-modal');
          EventBus.$emit('login-user', current_user);
          success_msg('登入成功');
          self.reset_form();
          EventBus.$emit('end-loading');
        })
        .catch(error => {
          error_msg(error.response['data']['message']);
          EventBus.$emit('end-loading');
        })
      },

      // 重置註冊登入表單
      reset_form: function() {
        this.email = '';
        this.login_email = '';
        this.password = '';
        this.login_password = '';
      },


    }

  }
</script>


<style lang='scss' scoped>
  .mask {
    z-index: 1050;
    position: fixed;
    top: 0;
    right: 0;
    width: 100vw;
    height: 100vh;
    background: rgba(0,0,0,.5);
    display:flex;
    align-items: center;
    justify-content: center;
  }

  .login-register-modal {
    z-index: 1060;
    position: fixed;
    top: 25%;
    right: 25%;
    width: 50vw;
    height: 50vh;
    background: #fff;
    display:flex;
    flex-direction:column;
    align-items: center;
    justify-content: center;
    i {
      color: #E7E7E7;
    }
  }
</style>


