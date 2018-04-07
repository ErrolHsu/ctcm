
  var app = new Vue({
    el: '#app',
    data: {
      message: 'Hello Vue!'
  	},
  	methods: {
  		say_hi: function() {
  			axios.get('/home/ajax')
  				.then(function(response) {
  					console.log(response.data.a);
  				})
  				.catch(function() {
  					console.log('error');
  				});
  		}
  	}
  })
