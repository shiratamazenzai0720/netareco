class Public::PostsController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update, :destroy]
  before_action :ensure_normal_user, only: [:new, :create]
  before_action :authenticate_user!,only: [:show, :edit]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    tag_list = params[:post][:tag_name].present? ? params[:post][:tag_name].split(',') : []
    if @post.save
      @post.save_tags(tag_list)
      redirect_to post_path(@post.id)
    else
      @posts = Post.all
      render :new
    end
  end

  def index
    @tag_list = PostTag.all
    if params[:latest]
      @posts = Post.latest
    elsif params[:old]
      @posts = Post.old
    elsif params[:rate]
      @posts = Post.rate
    elsif params[:favorites_count]
      @posts = Post.favorites_count
    else
      @posts = Post.all
    end
  end

  def show
    @post = Post.find(params[:id])
    @post_comment = PostComment.new
  end

  def edit
    @post = Post.find(params[:id])
    existing_tag_names = @post.tags.pluck(:name)
    @post.tag_name = existing_tag_names.join(',')
  end

  def update
    @post = Post.find(params[:id])
    tag_list = params[:post][:tag_name].present? ? params[:post][:tag_name].split(',') : []
    if @post.update(post_params)
      @post.save_tags(tag_list)
    redirect_to post_path(@post.id)
    else
      render :edit
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to user_path(current_user.id)
  end

  private
  
  def post_params
    params.require(:post).permit(:title, :body, :rate)
  end

  def is_matching_login_user
    post = Post.find(params[:id])
    unless post.user_id == current_user.id
      redirect_to posts_path
    end
  end

  def ensure_normal_user
    if current_user.guest_user?
      redirect_to posts_path, alert: "ゲストユーザーは投稿できません。"
    end
  end

end
