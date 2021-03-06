class ArticlesController < ApplicationController

  before_action :require_user, except: [:index, :show]
  before_action :require_user, only: [:edit, :update, :destroy]

  def index
    @articles = Article.order(:id).page(params[:page]).per(5)
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    flash[:danger] = "Article was successfully Deleted!"
    redirect_to articles_path
  end


  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    @article.user = current_user
    if @article.save
      flash[:success] = "Article was successfully Created!"
      redirect_to article_path(@article)
    else
      render 'new'
    end
  end

  def update
    @article = Article.find(params[:id])
    if @article.update(article_params)
      flash[:success] = "Article was successfully Updated!"
      redirect_to article_path(@article)
    else
      render 'new'
    end
  end

  def edit
    @article = Article.find(params[:id])
  end

  def show
    @article = Article.find(params[:id])
  end

  private
  def article_params
    params.require(:article).permit(:title, :description)
  end

  def require_same_user
    if current_user != @article.user and !current_user.admin?
      flash[:danger] = "You Can Only Edit or Delete Your Articles"
      redirect_to root_path
    end
  end
end