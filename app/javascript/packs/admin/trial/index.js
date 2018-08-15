import Vue from 'vue/dist/vue.esm'

document.addEventListener('DOMContentLoaded', () => {
  const adminTrialsApp = new Vue({
    el: '#admin_trials_app',
    data: {
      trials: {},
      trial_count: '',
      filter: 'undone',
    },

    mounted() {
      let self = this;
      // set CSRF Token
      const csrf_token = document.querySelector("meta[name=csrf-token]").content;
      axios.defaults.headers.common['X-CSRF-Token'] = csrf_token;

      // init data
      const element = document.getElementById("props");
      const props = JSON.parse(element.getAttribute('data'));
      self.trials = props.trials;
      self.trial_count = props.trial_count;
    },

    methods: {
      set_filter: function(filter) {
        let self = this;
        self.filter = filter;
        axios.post('/admin/trials/filter',{
          filter: self.filter,
        })
        .then((response) => {
          self.trials = Object.assign({}, response['data']['trials']);
        })
        .catch((error) => {
          error_msg(error.response['data']['message']);
        })
      },

      option: function(trial_id, action) {
        let self = this;
        let path;
        switch(action) {
        case 'shipping':
          path = '/admin/trials/' + trial_id + '/shipping'
          break;
        case 'reject':
          path = '/admin/trials/' + trial_id + '/request_reject'
          break;
        case 'reset':
          path = '/admin/trials/' + trial_id + '/reset'
          break;
        }

        axios.post(path, {
          filter: self.filter,
        })
        .then((response) => {
          self.trials = Object.assign({}, response['data']['trials']);
          success_msg(response['data']['message'])
        })
        .catch((error) => {
          error_msg(error.response['data']['message']);
        })
      },

      // 是否show還原按鈕
      can_be_reset: function(trial) {
        return (trial.status === 'shipped' || trial.status === 'reject')
      },

      // 翻譯status
      translate_status: function(status) {
        let str = ''
        switch(status) {
        case 'request':
          str = '試用申請'
          break;
        case 'reject':
          str = '已拒絕'
          break;
        case 'shipped':
          str = '已寄出'
          break;
        default:
          str = status
        }
        return str;
      },

      // 是否被選取
      selectedCheck: function(prop, str) {
        if (str === prop) {
          return "seleted";
        }
      },
    }
  })
})

