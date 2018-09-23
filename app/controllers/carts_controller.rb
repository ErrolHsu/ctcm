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
      order_set = params.permit(order_set: [ {product: [:id, :title]}, {variant: [:id, :weight]}, :frequency, :duration]).to_h['order_set']
      # order_set['weight'] = order_set['weight'].to_f
      # order_set['frequency'] = order_set['frequency'].to_i
      # order_set['duration'] = order_set['duration'].to_i

      # 檢查 period order_set
      unless check_order_set(order_set)
        render json: {message: '不合法的訂單資料'}, status: 400
        Rails.logger.warn('不合法的訂單資料')
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

  # def check_kind?(kind)
  #   allow = ['single_origin', 'blend', 'espresso']
  #   kind && kind.in?(allow)
  # end

  # def check_weight?(weight)
  #   allow = [0.25, 0.5, 1, 2]
  #   weight && weight.in?(allow)
  # end

  def check_order_set(order_set)
    product_id = order_set['product']['id']
    variant_id = order_set['variant']['id']
    frequency_allow = [1, 2, 3, 4]
    duration_allow = [3, 6, 9, 12]

    product = Product.find_by(id: product_id.to_i)
    variant = product.variants.find_by(id: variant_id.to_i)

    product.present? && variant.present? && order_set['frequency'].in?(frequency_allow) && order_set['duration'].in?(duration_allow)
  end

  def check_frequency?(frequency)
    frequency_allow = [1, 2, 3, 4]
    frequency && frequency.in?(frequency_allow)
  end

  def check_duration?(duration)
    allow = [3, 6, 9, 12]
    duration && duration.in?(allow)
  end

end
