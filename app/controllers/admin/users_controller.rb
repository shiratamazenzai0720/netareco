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
      redirect_to user_path(@user.id)
      else
        render :edit
      end
    end
  
    def destroy
      user = User.find(params[:id])
      user.destroy
      admin_users_path
    end
  
    def index
      @users = User.all
    end
  
    private
  
    def is_matching_login_user
      user = User.find(params[:id])
      unless user.id == current_user.id
        redirect_to posts_path
      end
    end
  
    def user_params
      params.require(:user).permit(:name, :profile_image, :email)
    end
end
