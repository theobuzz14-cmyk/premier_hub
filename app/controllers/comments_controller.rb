class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      # チーム詳細ではなく「スレッド詳細(post)」に戻る
      redirect_to team_post_path(@post.team, @post), notice: 'コメントを投稿しました'
    else
      # エラー時はスレッド詳細にそのまま戻す（後で改善可能）
      redirect_to team_post_path(@post.team, @post), alert: 'コメントの投稿に失敗しました'
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