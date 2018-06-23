class Admin::ProductsController < AdminController

  expose(:products) { Product.order('created_at ASC') }
  expose(:product)

  def index

  end

  def new

  end

  def create

    if product.save
      # 成功
      redirect_to admin_products_path
    else
      # 失敗
      render :new
    end
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
    params.require(:product).permit(:title, :description, :img)
  end
end
