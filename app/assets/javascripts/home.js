
  const app = new Vue({
    el: '#app',
    data: {
      message: 'Hello Vue!'
    },
    methods: {
      say_hi: function(num) {
        this.message = `now ${num}`
        axios.get('/home/ajax', {
            params: {
              t: num
            }
          })
          .then(function(response) {
            console.log(response.data.a);
          })
          .catch(function() {
            console.log('error');
          });
      }
    }
  })
