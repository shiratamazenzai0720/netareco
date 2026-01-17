class Admin::PostsController < ApplicationController
    before_action :authenticate_admin!

    def new
      @post = Post.new
    end
  
    def create
      @post = Post.new(post_params)
      if @post.save
        redirect_to admin_post_path(@post.id)
      else
        render :new
      end
    end
  
    def index
      @tag_list = PostTag.all
      @posts = Post.all
    
      if params[:tag_name].present?
        @posts = @posts.joins(:tags).where(tags: { name: params[:tag_name] })
      end
    
      if params[:latest]
        @posts = @posts.latest
      elsif params[:old]
        @posts = @posts.old
      elsif params[:rate]
        @posts = @posts.rate
      elsif params[:favorites_count]
        @posts = @posts.favorites_count
      else
        @posts = @posts.latest
      end
    end
  
    def show
      @post = Post.find(params[:id])
      @post_comment = PostComment.new
    end
  
    def edit
      @post = Post.find(params[:id])
    end
  
    def update
      @post = Post.find(params[:id])
      if @post.update(post_params)
        redirect_to admin_post_path(@post.id)
      else
        render :edit
      end
    end
  
    def destroy
      post = Post.find(params[:id])
      post.destroy
      redirect_to admin_posts_path, notice: "投稿を削除しました"
    end
  
    private
    
    def post_params
      params.require(:post).permit(:title, :body, :comedian_name)
    end
end
