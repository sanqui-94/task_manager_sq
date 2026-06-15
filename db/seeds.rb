# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

demo_user = User.find_or_initialize_by(email_address: "demo@example.com")
demo_user.password = "password123"
demo_user.password_confirmation = "password123"
demo_user.save!

puts "Seeded demo user: demo@example.com / password123"

if demo_user.tasks.none?
  demo_user.tasks.create!(title: "Set up project board", description: "Review the kanban columns and filters.", priority: :high)
  demo_user.tasks.create!(title: "Write documentation", priority: :medium)
  demo_user.tasks.create!(title: "Organize backlog", priority: :low, status: :in_progress)
  puts "Seeded sample tasks"
end
