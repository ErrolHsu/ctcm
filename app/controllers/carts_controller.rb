class CartsController < ApplicationController

  expose(:product) { Product.find_by(id: params[:product_id]) }

  def add
    current_cart.add_item(params[:id])
    # session[current_user.id] = current_cart.serialize
    redirect_to admin_products_path, notice: '已加入購物車'
  end

  def destroy
    # session[current_user.id] = nil
    current_cart.cart_items.delete_all
    redirect_to admin_products_path, notice: "購物車已清空"
  end

  def checkout
  end

  # encode period order_set
  def jwt_encode
    begin
      order_set = params.permit(order_set: [:kind, :weight, :frequency, :duration]).to_h['order_set']
      order_set['weight'] = order_set['weight'].to_f
      order_set['frequency'] = order_set['frequency'].to_i
      order_set['duration'] = order_set['duration'].to_i

      # 檢查 period order_set
      unless check_kind?(order_set['kind']) && check_weight?(order_set['weight']) && check_frequency?(order_set['frequency']) && check_duration?(order_set['duration'])
        render json: {message: 'FAIL'}, status: 400
        return
      end
      token = JwtHelper::Encode.call(order_set)

      render json: { token: token }, status: 200
    rescue => e
      Rails.logger.error("#{e}, file: #{__FILE__}, line: #{__LINE__}")
      render json: {message: 'FAIL'}, status: 500
    end
  end

  # decode period order_set
  def jwt_decode
    begin
      decode_token = JwtHelper::Decode.call(params['token'])
      payload = decode_token.payload

      render json: { token_payload_json: payload.to_json }, status: 200
    rescue => e
      Rails.logger.error("#{e}, file: #{__FILE__}, line: #{__LINE__}")
      render json: { message: 'FAIL' }, status: 500
    end
  end

  private

  def check_kind?(kind)
    allow = ['single_origin', 'blend', 'espresso']
    kind && kind.in?(allow)
  end

  def check_weight?(weight)
    allow = [0.25, 0.5, 1, 2]
    weight && weight.in?(allow)
  end

  def check_frequency?(frequency)
    allow = [1, 2, 3, 4]
    frequency && frequency.in?(allow)
  end

  def check_duration?(duration)
    allow = [3, 6, 9, 12]
    duration && duration.in?(allow)
  end

end
