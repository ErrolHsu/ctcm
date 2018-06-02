const new_product_app = new Vue({
  el: '#new_product_app',
  data: {
    markdown_preview: '',
  },

  methods: {
    parse_markdown: function(str) {
      let reader = new commonmark.Parser();
      let writer = new commonmark.HtmlRenderer();
      let parsed = reader.parse(str)
      let result = writer.render(parsed)
      return result
    },

    show_markdown_preview: function(e) {
      let input_str = e.target.value;
      let parsed_str = this.parse_markdown(input_str);
      this.markdown_preview = parsed_str;
    }
  }
})
