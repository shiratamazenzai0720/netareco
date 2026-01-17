class Admin::SearchesController < ApplicationController
    before_action :authenticate_admin!

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
		end

		if params[:latest]
			@records = @records.latest
		  elsif params[:old]
			@records = @records.old
		  elsif params[:rate]
			@records = @records.rate
		  elsif params[:favorites_count]
			@records = @records.favorites_count
		end
	end
end