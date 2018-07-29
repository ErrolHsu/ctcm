require "uri"
require "net/http"
class HomeController < ApplicationController
  expose(:products) { Product.all }
  expose(:product_json) { Product.includes(:variants).to_json(include: :variants) }

  def index

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
    if trial_params.except(:message, :product_name).to_h.any? { |key, value| value.blank? }
      render json: { message: "除 \'意見\' 外其餘欄位均為必填！" }, status: 500
      return
    end

    begin
      Trial.create!(trial_params)
      render json: { message: 'SUCCESS' }, status: 200
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
