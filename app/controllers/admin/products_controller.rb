class Admin::ProductsController < AdminController

  expose(:products) { Product.order('created_at ASC') }
  expose(:product)

  def index

  end

  def new

  end

  def create

    variants = JSON.parse(params['variants_json']) if params['variants_json']
    ActiveRecord::Base.transaction do
      product.save!
      if variants.present?
        variants.each do |variant|
          next if variant.values.any? { |value| value.blank? }
          product.variants.create!(variant)
        end
      end
    end
    redirect_to admin_products_path
  end

  def show
  end

  def edit

  end

  def update
    if product.update(product_params)
      # 成功
      redirect_to admin_products_path
    else
      # 失敗
      render :edit
    end
  end

  def destroy
    product.destroy if product
    redirect_to admin_products_path
  end

  private
  def product_params
    params.require(:product).permit(:title, :description, :period_order_only, :img)
  end
end
