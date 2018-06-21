class HomeController < ApplicationController
  expose(:products) { Product.all }

  def index
    @t = 123
  end

  def ajax
    num = params[:t]
    render json: {a: num}.to_json
    puts response.body
  end

end
