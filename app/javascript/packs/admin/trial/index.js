import Vue from 'vue/dist/vue.esm'

document.addEventListener('DOMContentLoaded', () => {
  const adminTrialsApp = new Vue({
    el: '#admin_trials_app',
    data: {
      trials: {},
    },

    mounted() {
      let self = this
      // set CSRF Token
      const csrf_token = document.querySelector("meta[name=csrf-token]").content;
      axios.defaults.headers.common['X-CSRF-Token'] = csrf_token;

      // init data
      const element = document.getElementById("props");
      const props = JSON.parse(element.getAttribute('data'));
      self.trials = props.trials;
    },

    methods: {
      option: function(trial_id, action) {
        let self = this
        console.log(action)
        console.log(self.trials[trial_id].status)
        if(action === self.trials[trial_id].status) {
          return
        }

        axios.post('/admin/trials/' + trial_id + '/option',{
          status: action,
        })
        .then((response) => {
          self.trials[trial_id] = response['data']['trial']
          success_msg(response['data']['message'])
        })
        .catch((error) => {
          error_msg(error.response['data']['message']);
        })
      },

    }
  })
})

