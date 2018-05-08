class Admin::ProductsController < AdminController
  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      # 成功
      redirect_to admin_products_path
    else
      # 失敗
      render :new
    end
  end 

  def edit
    @product = Product.find_by(id: params[:id])
  end  

  def update
    @product = Product.find_by(id: params[:id])

    if @product.update(product_params)
      # 成功
      redirect_to admin_products_path
    else
      # 失敗
      render :edit
    end
  end

  def destroy
    @product = Product.find_by(id: params[:id])
    @product.destroy if @product
    redirect_to admin_products_path
  end

  private
  def product_params
    params.require(:product).permit(:title, :description, :price, :quantity)
  end  
end
