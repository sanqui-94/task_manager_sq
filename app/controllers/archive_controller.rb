class ArchiveController < ApplicationController
  def index
    @tasks = current_user.tasks.archived_records.order(archived_at: :desc)
  end
end
