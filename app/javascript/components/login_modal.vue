<template>

  <div>
    <!-- 遮罩 -->
    <div class='mask' v-show='display' v-on:click.stop='hideLoginModal'>
    </div>

    <!-- login & register modal -->
    <transition name='opacity'>
      <div class='login-register-modal' v-show='display'>
        <h5 class='center mt-3 mb-3'>登入或註冊以繼續</h5>
        <hr>
        <div class='flex-box mb-3'>
          <!-- 註冊表單 -->
          <div class='register-box' v-show='register_form'>
            <h6 class='mb-3'>成為會員</h6>
            <div class="form-group">
              <input type="email" class="form-control"
              v-model='email' placeholder="Email">
            </div>

            <div class="form-group">
              <input type='password' class="form-control"
              v-model='password' placeholder='密碼'>
            </div>

            <div class="form-group">
              <input type='password' class="form-control"
              v-model='password_confirm' placeholder='密碼確認'>
            </div>

            <div class='btn button-full' v-on:click='register'>註冊</div>
            <div class='small mt-2 pointer'style='color: #4267b2' @click='displayLoginForm'>會員登入</div>
          </div>


          <!-- 登入表單 -->
          <div class='login-box' v-show='login_form'>
            <h6 class='mb-3'>會員登入</h6>

            <div class="form-group">
              <input type="email" class="form-control"
              v-model='login_email' placeholder="請輸入Email">
            </div>

            <div class="form-group">
              <input type='password' class="form-control"
              v-model='login_password' placeholder='請輸入密碼'>
            </div>

            <div class='btn button-full' v-on:click='login'>登入</div>
            <div class='small mt-2 pointer'style='color: #4267b2' @click='displayRegisterForm'>註冊新會員</div>
          </div>
        </div>

        <hr>

        <div class='center mb-3'>
          <div class='mb-3'>OR</div>
          <div class='btn btn-facebook' @click="facebookLogin">以 Facebook 帳號繼續</div>
          <!-- <div class='' @click="facebookLogout">登出</div> -->
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
        //display 表單
        register_form: false,
        login_form: true,
        // 註冊
        email: '',
        password: '',
        password_confirm: '',
        // 登入
        login_email: '',
        login_password: '',
        // fb accessToken
        access_token: '',
      }
    },

    mounted() {
      let self = this;
      window.fbAsyncInit = function() {
        FB.init({
          appId      : '1946477608986227',
          cookie     : true,
          xfbml      : true,
          version    : 'v3.1',
        });

        FB.AppEvents.logPageView();
        // Get FB Login Status
        FB.getLoginStatus( response => {
          if (response.status === 'connected') {
            // self.access_token = response.authResponse.accessToken;
          }
        })
      };

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

      displayRegisterForm () {
        this.register_form = true;
        this.login_form = false;
      },

      displayLoginForm () {
        this.register_form = false;
        this.login_form = true;
      },

      // 註冊
      register: function() {
        let self = this;
        if(this.password !== this.password_confirm) {
          error_msg('請輸入相同的密碼');
          return
        }

        EventBus.$emit('loading');
        axios.post('/user_sign_up', {
          email: self.email,
          password: self.password,
        })
        .then(response => {
          self.loginCallBack(response);
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
          self.loginCallBack(response);
        })
        .catch(error => {
          console.log(error)
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

      loginCallBack(response) {
        let current_user = response['data']['current_user'];
        EventBus.$emit('hide-login-modal');
        EventBus.$emit('login-user', current_user);
        success_msg('你已成功登入');
        this.reset_form();
        EventBus.$emit('end-loading');
      },

      facebookLogin: function() {
        let self = this;
        let scope = {
          scope: 'email, public_profile',
          return_scopes: true
        }
        EventBus.$emit('loading');
        FB.login(async function (response) {
          console.log('res', response)
          if (response.status === 'connected') {
            self.access_token = response.authResponse.accessToken;
            let user_profile = await self.getProfile();
            axios.post('/user_facebook_login', {
              access_token: self.access_token,
              user_profile: user_profile,
            })
            .then(res => {
              self.loginCallBack(res);
            })
            .catch(err => {
              error_msg(err.response['data']['message']);
              EventBus.$emit('end-loading');
            })
          } else {
            error_msg('FACEBOOK登入失敗');
            EventBus.$emit('end-loading');
          }
        }, scope);
      },

      facebookLogout () {
        let self = this;
        FB.logout(function (response) {
          console.log('res when logout', response)
        })
      },

      getProfile () {
        return new Promise((resolve, reject) => {
          FB.api('/me?fields=name,id,email', function (response) {
            console.log('res in graphAPI', response)
             resolve(response);
          })
        })
      },

    }

  }
</script>


<style lang='scss' scoped>
  .mask {
    -webkit-transform: translate3d(0,0,0);
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
    -webkit-transform: translate3d(0,0,0);
    z-index: 1060;

    -webkit-transform:translateZ(1px);
    -moz-transform:translateZ(1px);
    -o-transform:translateZ(1px);
    transform:translateZ(1px);

    position: fixed;
    top: 15%;
    right: 25%;
    width: 50vw;
    height: auto;
    background: #fff;
    .flex-box {
      display:flex;
      align-items: flex-end;
      justify-content: space-around;
    }
  }

  .register-box {
    width: 60%;
  }

  .login-box {
    width: 60%;
  }

  @media screen and (max-width: 767.98px) {
    .login-register-modal {
      top: 10%;
      right: 10%;
      width: 80vw;
      min-height: 70vh;
      .flex-box {
        flex-direction:column;
        align-items: center;
        // justify-content: center;
      }
    }

    .register-box {
      width: 80%;
    }

    .login-box {
      width: 80%;
    }
  }
</style>


