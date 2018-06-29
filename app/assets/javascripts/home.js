const home_page_app = new Vue({
  el: '#home_page_app',
  mixins: [markDown],
  data: {
    products: [],
    periods: ['每週', '隔週', '三週', '每月'],
    times: [1, 2, 3, 4],
    current_variants: [],
    customer_set: {
      product_id: 0,
      variant_id: 0,
      period: '',
      time: '',
      address: '',
    },

  },

  mounted() {
    let self = this

    // set CSRF Token
    const csrf_token = document.querySelector("meta[name=csrf-token]").content
    axios.defaults.headers.common['X-CSRF-Token'] = csrf_token

    axios.get('/home/initialize_data')
      .then(function(response) {
        self.products = JSON.parse(response['data']['products'])
      });
  },

  computed: {
    show_address_input: function() {
      return ( this.customer_set_item_completed )
    },

    show_buy_button: function() {
      return (
        this.customer_set_item_completed && this.customer_set.address.length != 0
      )
    },

    customer_set_item_completed: function() {
      return (
        this.customer_set.product_id != 0 &&
        this.customer_set.variant_id != 0 &&
        this.customer_set.period.length != 0 &&
        this.customer_set.time
      )
    },
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

    time_seleted: function(time) {
      this.customer_set.time = time;
    },

    reset: function() {
      this.customer_set.product_id = 0;
      this.customer_set.variant_id = 0;
      this.customer_set.period = '';
      this.customer_set.time = '';
    },

    seleted: function(a, b) {
      if(a == b) {
        return {background: '#fff', color: '#444'}
      }
    },

    // 下單
    order_request: function() {
      let self = this;
      axios.post('orders/create_period_order', {
        customer_set: self.customer_set,
      })
      .then(function(response) {
        success_msg(response['data']['message']);
      })
    },

  }
})
