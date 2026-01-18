class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to team_post_path(@post.team, @post), notice: 'コメントを投稿しました'
    else
      redirect_to team_post_path(@post.team, @post), alert: 'コメントを入力してください'
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