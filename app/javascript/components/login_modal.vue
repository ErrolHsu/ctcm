<template>

  <div>
    <div class='mask' v-show='display' v-on:click.stop='hideLoginModal'>
    </div>
    <transition name='opacity'>
      <div class='login-modal' v-show='display'>
        xxxxxxxxxx
      </div>
    </transition>
  </div>

</template>

<script>
  import { EventBus } from '../event_bus.js';
  export default {
    data: function () {
      return {
        display: false
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

  .login-modal {
    z-index: 1060;
    position: fixed;
    top: 25%;
    right: 25%;
    width: 50vw;
    height: 50vh;
    background: #fff;
    display:flex;
    align-items: center;
    justify-content: center;
    i {
      color: #E7E7E7;
    }
  }
</style>


