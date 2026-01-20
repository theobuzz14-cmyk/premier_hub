class SearchesController < ApplicationController
  def index
    @query = params[:query]
    if @query.present?
      # タイトルか本文にキーワードが含まれる投稿を検索
      @posts = Post.where('title LIKE ? OR body LIKE ?', "%#{@query}%", "%#{@query}%")
                   .order(created_at: :desc)
    else
      @posts = Post.none
    end
  end
end