<template>
  <div v-show='loading' id='loader' class='loader z2060'>
    <i class="fa fa-spinner fa-pulse fa-5x fa-fw"></i>
    <span class="sr-only">Loading...</span>
  </div>
</template>

<script>
  import { EventBus } from '../event_bus.js';
  export default {
    data: function () {
      return {
        loading: false,
      }
    },

    mounted() {
      let self = this
      EventBus.$on('loading', function() {
        self.loading = true
      });

      EventBus.$on('end-loading', function() {
        self.loading = false
      });
    },

  }
</script>


<style lang='scss' scoped>
  .loader {
    position: fixed;
    top: 0;
    right: 0;
    width: 100vw;
    height: 100vh;
    background: rgba(0,0,0,.5);
    opacity: 0.8;
    display:flex;
    align-items: center;
    justify-content: center;
    i {
      color: #E7E7E7;
    }
  }
</style>


