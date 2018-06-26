const home_page_app = new Vue({
  el: '#home_page_app',
  mixins: [markDown],
  data: {
    products: [],
    periods: ['每週', '隔週', '三週', '每月'],
    current_variants: [],
    customer_set: {
      product_id: 0,
      variant_id: 0,
      period: '',
    },

  },

  mounted() {
    let self = this
    axios.get('/home/initialize_data')
      .then(function(response) {
        console.log(JSON.parse(response['data']['products']))
        self.products = JSON.parse(response['data']['products'])
      });
  },

  methods: {
    // 選定產品
    product_selected: function(product) {
      this.reset();
      this.customer_set.product_id = product.id;
      this.current_variants = product.variants;
    },

    // 選定重量
    variant_seleted: function(variant) {
      this.customer_set.variant_id = variant.id;
    },

    // 選定週期
    period_seleted: function(period) {
      this.customer_set.period = period;
    },

    reset: function() {
      this.customer_set = {
        product_id: 0,
        variant_id: 0,
        period: '',
      }
    }

  }
})
