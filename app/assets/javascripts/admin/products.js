const new_product_app = new Vue({
  el: '#new_product_app',
  mixins: [markDown],
  data: {
    variants: [{
      weight: '',
      price: 0,
      quantity: 0,
    }]
  },

  methods: {
  }
})
