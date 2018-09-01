<template>
  <div>
    <a href="#" v-on:click.prevent='ShowLoginModal'>
      註冊 / 登入
    </a>
  </div>
</template>

<script>
  import { EventBus } from '../event_bus.js';
  export default {
    data: function () {
      return {

      }
    },

    mounted() {

    },

    methods: {
      ShowLoginModal: function() {
        EventBus.$emit('show-login-modal');
      },


    }

  }
</script>


<style lang='scss' scoped>

</style>


