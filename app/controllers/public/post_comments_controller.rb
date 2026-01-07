class Public::PostCommentsController < ApplicationController
    before_action :authenticate_user!
    before_action :is_matching_login_user, only: [:edit, :update, :destroy]
    
    def create
        post = Post.find(params[:post_id])
        comment = current_user.post_comments.new(post_comment_params)
        comment.post_id = post.id
        if comment.save
            redirect_to post_path(post)
        else
            redirect_to post_path(post), alert: "コメントの投稿に失敗しました"
        end
    end

    def edit
    end

    def update
        if @post_comment.update(post_comment_params)
        redirect_to post_path(@post_comment.post.id), notice: "コメントを更新しました"
        else
          render :edit
        end
    end

    def destroy
        @post_comment.destroy
        redirect_to post_path(params[:post_id]), notice: "コメントを削除しました"
    end

    private

    def is_matching_login_user
        @post_comment = PostComment.find(params[:id])
        unless @post_comment.user_id == current_user.id
          redirect_to posts_path
        end
      end

    def post_comment_params
        params.require(:post_comment).permit(:comment)
    end
end
