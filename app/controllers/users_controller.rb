class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :show]
  before_action :require_user, only: [:edit, :update, :destroy]
  before_action :require_admin, only: [:destroy]
  def index
    @users = User.order(:id).page(params[:page]).per(5)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "Welcome to The Blog #{@user.username}"
      redirect_to user_path(@user)
    else
      render 'new'
    end
  end

  def edit

  end

  def update

    if @user.update(user_params)
      flash[:success] = "Successfully Updated"
      redirect_to articles_path
    else
      render 'edit'
    end
  end

  def show
    @user_articles = User.find(params[:id]).articles.order(:id).page(params[:page]).per(5)
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:danger] = "Successfully Deleted User"
    redirect_to users_path
  end


  private
  def user_params
    params.require(:user).permit(:username,:email,:password)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def require_same_user
    if  current_user != @user and !current_user.admin?
      flash[:danger] = "You Can Only Edit Your Own Account"
      redirect_to root_path
    end
  end

  def require_admin
    if !current_user.admin?
      flash[:danger] = "Only Admin Users can perform that actions"
      redirect_to root_path
    end
  end
end