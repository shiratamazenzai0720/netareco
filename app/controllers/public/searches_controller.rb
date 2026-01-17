class Public::SearchesController < ApplicationController
    before_action :authenticate_user!

	def search
		@model = params[:model]
		@content = params[:content]
		@method = params[:method]

		if @model == 'user'
			@records = User.search_for(@content, @method)
		elsif @model == 'post'
			@records = Post.search_for(@content, @method)
		elsif @model == 'tag'
			@records = Tag.search_posts_for(@content, @method)
		else
			@records = Post.all
		end

		if params[:latest]
			@records = @records.latest
		elsif params[:old]
			@records = @records.old
		elsif params[:rate]
			@records = @records.rate
		elsif params[:favorites_count]
			@records = @records.favorites_count
		else
			if @records.is_a?(ActiveRecord::Relation)
			  @records = @records.latest
			else
			  @records = @records.sort_by(&:created_at).reverse
			end
		end
	end
end