<template>
  <span class='center d-block'  v-if='current_user_present'>
    <div class='bottom-line'>
      <a href="/account/index" style='font-size: 19px; !important'>
        {{ current_user.email }}
      </a>
    </div>
    <div class='bottom-line'>

      <a href="#" v-on:click.prevent='signOutUser'>
        登出
      </a>
    </div>
  </span>
  <span class='center d-block' v-else>
    <div class='bottom-line'>
      <a href="#" v-on:click.prevent='ShowLoginModal'>
        註冊 / 登入
      </a>
    </div>
  </span>
</template>

<script>
  import { EventBus } from '../event_bus.js';
  import axios from 'axios';

  export default {
    props: ['current_user', 'user_login'],
    data: function () {
      return {

      }
    },

    mounted() {

    },

    methods: {
      ShowLoginModal: function() {
        EventBus.$emit('show-login-modal');
        EventBus.$emit('hide-phone-options');
      },

      signOutUser: function() {
        axios.get('/user_sign_out')
          .then((response) => {
            EventBus.$emit('sign-out-user');
            success_msg('成功登出');
          })
          .catch((err) => {
            error_msg(err['data']['message'])
          })

      },

    },

    computed: {
      current_user_present: function() {
        return this.user_login;
      },


    },

  }
</script>


<style lang='scss' scoped>

</style>


