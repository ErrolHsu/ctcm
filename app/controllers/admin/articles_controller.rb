class Admin::ArticlesController < AdminController
  expose :articles, -> { Article.all }
  expose :article

  def index
  end

  def new

  end

  def create
    if article.save
      redirect_to admin_articles_path
    else
      render :new
    end
  end

  def edit

  end

  def update
    if article.update(article_params)
      redirect_to admin_articles_path
    else
      render :edit
    end
  end

  def destroy
    article.destroy
    redirect_to admin_articles_path
  end

  private

  def article_params
    params.require(:article).permit(:title, :content)
  end

end
