class SearchesController < ApplicationController
  before_action :authenticate_user!

  def index
    @query = params[:query]
    @model = params[:model] # 'post' か 'user' が入る

    if @model == 'user'
      @results = User.active
                     .where("name LIKE ?", "%#{@query}%")
                     .order(:name)
    else
      @results = Post.includes(:team)
                     .where("title LIKE ? OR body LIKE ?", "%#{@query}%", "%#{@query}%")
                     .order(created_at: :desc)
    end
  end
end