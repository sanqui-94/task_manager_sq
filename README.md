# Task Manager SQ

A personal kanban task manager built with Ruby on Rails 8, PostgreSQL, Tailwind CSS, and Dev Containers.

## Features

- 3-column kanban board: To-do, In progress, Done
- Task priorities (high, medium, low) with stack ordering and board filters
- Human-readable task codes (e.g. `GT-001`) plus UUID primary keys
- Task details with status changes, comments (author + date), and archiving
- Email/password authentication with password reset
- Private tasks per user

## Dev Container setup

Requires [Docker Desktop](https://www.docker.com/products/docker-desktop/) and the Dev Containers extension in Cursor/VS Code.

1. Open this folder in Cursor
2. Run **Dev Containers: Reopen in Container**
3. On first boot, `bin/setup --skip-server` runs automatically
4. Start the app:

```bash
bin/dev
```

Visit http://localhost:3000

### Manual bootstrap (without reopening in container)

```bash
docker compose -f .devcontainer/compose.yaml up -d postgres
docker compose -f .devcontainer/compose.yaml run --rm --user vscode -e DB_HOST=postgres -w /workspaces/task_manager_sq rails-app bash -lc 'eval "$(~/.local/bin/mise activate bash)" && bundle install && bin/setup'
```

## Demo credentials

After running seeds:

- Email: `demo@example.com`
- Password: `password123`

```bash
bin/rails db:seed
```

## Development commands

```bash
bin/dev                 # Rails + Tailwind watcher
bin/rails db:migrate    # Run migrations
bin/rails db:seed       # Seed demo user and sample tasks
bin/rails console       # Rails console
```

## Architecture notes

- Tasks are scoped to the logged-in user
- Status changes happen on the task detail page (no drag-and-drop in v1)
- Archived tasks are hidden from the board and listed at `/archive`
- Password reset emails open via Letter Opener in development
