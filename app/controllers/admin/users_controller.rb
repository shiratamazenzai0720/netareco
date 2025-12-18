class Admin::UsersController < ApplicationController
    before_action :authenticate_admin!
    def show
      @user = User.find(params[:id])
      @posts = @user.posts
    end
  
    def edit
      @user = User.find(params[:id])
    end
  
    def update
      @user = User.find(params[:id])
      if @user.update(user_params)
      redirect_to admin_user_path(@user.id)
      else
        render :edit
      end
    end
  
    def destroy
      user = User.find(params[:id])
      user.destroy
      redirect_to admin_users_path, notice: "ユーザーを退会させました。"
    end
  
    def index
      @users = User.all
    end
  
    private
  
    def user_params
      params.require(:user).permit(:name, :profile_image, :email)
    end
end
