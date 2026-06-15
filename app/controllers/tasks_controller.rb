class TasksController < ApplicationController
  before_action :set_task, only: %i[ show update archive unarchive ]

  def show
    @comment = @task.comments.build
  end

  def new
    @task = current_user.tasks.build(priority: :medium)
  end

  def create
    @task = current_user.tasks.build(task_params)
    @task.status = :todo

    if @task.save
      redirect_to root_path, notice: "Task #{@task.code} created."
    else
      @priorities = Task.priorities.keys
      @todo_tasks = current_user.tasks.active.by_column(:todo).with_priorities(@priorities).stack_ordered
      @in_progress_tasks = current_user.tasks.active.by_column(:in_progress).with_priorities(@priorities).stack_ordered
      @done_tasks = current_user.tasks.active.by_column(:done).with_priorities(@priorities).stack_ordered
      render "board/show", status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      redirect_to task_path(@task), notice: "Task updated."
    else
      @comment = @task.comments.build
      render :show, status: :unprocessable_entity
    end
  end

  def archive
    @task.archive!
    redirect_to root_path, notice: "Task #{@task.code} archived."
  end

  def unarchive
    @task.unarchive!
    redirect_to task_path(@task), notice: "Task #{@task.code} restored."
  end

  private

    def set_task
      @task = current_user.tasks.find_by!(code: params[:code])
    end

    def task_params
      params.require(:task).permit(:title, :description, :status, :priority)
    end
end
