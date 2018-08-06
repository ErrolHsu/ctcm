const HomePageApp = new Vue({
  el: '#home_page_app',
  mixins: [markDown],
  data: {
    trial: {
      name: '',
      email: '',
      phone: '',
      address: '',
      message: '',
      product_name: '',
    }


    // products: [],

    // // 定期訂單相關
    // periods: [],
    // limits: [],
    // current_variants: [],
    // customer_set: {
    //   product_id: 0,
    //   variant_id: 0,
    //   period: '',
    //   limit: '',
    //   address: '',
    // },

    // // 付款相關
    // order: {},
    // ecpay_info: {},


  },

  mounted() {
    let self = this
    // set CSRF Token
    const csrf_token = document.querySelector("meta[name=csrf-token]").content;
    axios.defaults.headers.common['X-CSRF-Token'] = csrf_token;

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
        this.customer_set.limit
      )
    },
  },

  methods: {
    selectTrialProduct: function(product_name) {
      this.trial.product_name = product_name;
    },

    trialRequest: function() {
      let self = this;
      axios.post('/home/trial_request', {
        trial_info: {
          name: self.trial.name,
          phone: self.trial.phone,
          address: self.trial.address,
          email: self.trial.email,
          message: self.trial.message,
          product_name: self.trial.product_name,
        }
      })
      .then(function(response) {
        success_msg(response['data']['message']);
        self.clearTrialInput();
      })
      .catch(function(error) {
        error_msg(error.response['data']['message']);
      })
    },

    clearTrialInput: function() {
      this.trial = {
        name: '',
        email: '',
        phone: '',
        address: '',
        message: '',
        product_name: '',
      }
    },

    // 是否被選取
    selectedCheck: function(prop, str) {
      if (str === prop) {
        return "seleted";
      }
    },


    // 暫時用不到.......
    // get products data
    get_products: function() {
      let self = this;
      axios.get('/home/initialize_data')
        .then(function(response) {
          self.products = JSON.parse(response['data']['products']);
          self.periods = response['data']['periods']
          self.limits = response['data']['limits']
        });
    },

    // 是否出現付款連結
    object_present: function(object) {
      return object_present(object);
    },

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
      this.customer_set.period = period.value;
    },

    // limit
    limit_seleted: function(limit) {
      this.customer_set.limit = limit.value;
    },

    reset: function() {
      this.customer_set.variant_id = 0;
      this.customer_set.period = '';
      this.customer_set.limit = '';
    },

    // 是否選中
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
        self.order = JSON.parse(response['data']['order']);
      })
    },

    // 產生ecpay付款所需資料
    go_to_pay: function() {
      let self = this;
      axios.post('/orders/ecpay_generate', {
        order_id: self.order.id
      })
      .then(function(response) {
        self.ecpay_info = Object.assign({}, response['data']['ecpay_info']);
      })
      .then(function(response) {
        document.getElementById('ecpay_info_form').submit();
      })
      .catch(function(error) {
        error_msg(error.response['data']['message']);
      })
    },

  }
})
