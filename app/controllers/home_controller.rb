require "uri"
require "net/http"
class HomeController < ApplicationController
  expose(:products) { Product.all }
  expose(:product_json) { Product.includes(:variants).to_json(include: :variants) }

  def landing_page

  end

  def index

  end

  def find_period_order_products
    period_order_products = Product.includes(:variants).where(period_order_only: true)
    period_order_products_json = period_order_products.as_json(include: {variants: {only: [:id, :weight, :price]}}, only: [:id, :title] )

    render json: { period_order_products:  period_order_products_json}, status: 200
  end

  def initialize_data
    render json: {
      products: product_json,
      periods: Reference::Period.to_hash,
      limits: Reference::Limit.to_hash,
    }
  end

  # 索取試用
  def trial_request
    # 除message外均必填
    h = {'name' => '姓名', 'address' => '地址', 'phone' => '電話', 'email' => '電子信箱'}
    empty_column = ''
    trial_params.except(:message, :product_name).each do |key, value|
      empty_column << " #{h[key]}" if value.blank?
    end


    if empty_column.present?
      render json: { message: "請填寫#{empty_column}" }, status: 500
      return
    end

    begin
      Trial.create!(trial_params)
      render json: { message: '感謝您的填寫，我們將以Email通知您結果。' }, status: 200
    rescue => e
      Rails.logger.error(e)
      render json: { message: '發生錯誤，請稍候重試。' }, status: 500
    end
  end

  private

  def trial_params
    params.require(:trial_info).permit(:name, :address, :email, :phone, :message, :product_name)
  end

end
