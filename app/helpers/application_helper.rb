module ApplicationHelper
  PRIORITY_BADGE_CLASSES = {
    "high" => "bg-red-100 text-red-800",
    "medium" => "bg-amber-100 text-amber-800",
    "low" => "bg-gray-100 text-gray-700"
  }.freeze

  def priority_badge_classes(priority)
    PRIORITY_BADGE_CLASSES.fetch(priority.to_s, PRIORITY_BADGE_CLASSES["low"])
  end

  def priority_filter_active?(priority, selected_priorities)
    selected_priorities.include?(priority.to_s)
  end

  def board_path_with_priorities(selected_priorities)
    if selected_priorities.sort == Task.priorities.keys.sort
      root_path
    else
      root_path(priorities: selected_priorities.join(","))
    end
  end

  def toggle_priority_filter(priority, selected_priorities)
    current = selected_priorities.map(&:to_s)
    updated =
      if current.include?(priority.to_s)
        current - [ priority.to_s ]
      else
        current + [ priority.to_s ]
      end

    updated = Task.priorities.keys if updated.empty?
    board_path_with_priorities(updated)
  end
end
