
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
      },
      render_mark: function() {
        str = '### 33333'
        var reader = new commonmark.Parser({smart: true});
        var writer = new commonmark.HtmlRenderer();
        var parsed = reader.parse(str);
        var result = writer.render(parsed);
        return result
      }
    }
  })
