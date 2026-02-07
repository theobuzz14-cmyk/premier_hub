class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to team_post_path(@post.team, @post), notice: 'コメントを投稿しました'
    else
      @team = @post.team
      #「停止ユーザーを除外するスコープ」を使いつつ、全コメントを取得
      @comments = @post.comments.active_user.includes(:user).order(created_at: :desc)
      
      flash.now[:alert] = 'コメントを入力してください'
      render "posts/show"
    end
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment.destroy
    redirect_to team_post_path(@comment.post.team, @comment.post), notice: 'コメントを削除しました'
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end