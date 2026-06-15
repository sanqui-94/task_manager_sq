class BoardController < ApplicationController
  def show
    @priorities = selected_priorities
    @todo_tasks = filtered_tasks(:todo)
    @in_progress_tasks = filtered_tasks(:in_progress)
    @done_tasks = filtered_tasks(:done)
    @task = current_user.tasks.build(priority: :medium)
  end

  private

    def filtered_tasks(status)
      current_user.tasks
        .active
        .by_column(status)
        .with_priorities(@priorities)
        .stack_ordered
    end

    def selected_priorities
      values = Array(params[:priorities]).flat_map { |value| value.to_s.split(",") }.map(&:strip).reject(&:blank?)
      return Task.priorities.keys if values.blank?

      values & Task.priorities.keys
    end
end
