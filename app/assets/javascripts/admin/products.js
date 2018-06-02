const new_product_app = new Vue({
  el: '#new_product_app',
  data: {
    description: '',
    str: '',
  },

  methods: {
    parse_markdown: function() {
      var reader = new commonmark.Parser();
      var writer = new commonmark.HtmlRenderer();
      var parsed = reader.parse(this.description)
      this.str = writer.render(parsed);
    }
  }
})
