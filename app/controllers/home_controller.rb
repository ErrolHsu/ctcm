class HomeController < ApplicationController
  expose(:products) { Product.all }
  expose(:product_json) { Product.includes(:variants).to_json(include: :variants) }

  def index
    @t = 123
  end

  def initialize_data

    render json: {products: product_json}
  end

end
