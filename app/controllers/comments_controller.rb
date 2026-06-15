class CommentsController < ApplicationController
  before_action :set_task

  def create
    @comment = @task.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to task_path(@task), notice: "Comment added."
    else
      redirect_to task_path(@task), alert: @comment.errors.full_messages.to_sentence
    end
  end

  private

    def set_task
      @task = current_user.tasks.find_by!(code: params[:task_code])
    end

    def comment_params
      params.require(:comment).permit(:body)
    end
end
