class PostsController < ApplicationController
  def new
    @post = Post.new
  end

  def create
    post = Post.new(post_params)
    post.save
    @post.user_id = current_user.id
    redirect_to'/top'
  end

  def index
  end

  def show
  end

  def edit
  end

  private
  
  def post_params
    params.require(:post).permit(:title,:body)
  end
end
