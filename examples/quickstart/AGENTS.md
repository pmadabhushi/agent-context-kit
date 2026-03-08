# AGENTS.md — Todo App

> This file is read automatically by AI agents at session start.

## Service Overview

- **Service:** TodoAPI
- **Language:** Python (FastAPI)
- **Database:** SQLite (dev), PostgreSQL (prod)
- **Hosting:** Docker on a single VPS
- **Repo:** https://github.com/yourname/todo-app

## Build & Run

```bash
# Install dependencies
pip install -r requirements.txt

# Run locally
uvicorn main:app --reload --port 8000

# Run tests
pytest tests/ -v

# Build Docker image
docker build -t todo-app .
```

## Branch Strategy

- Main branch: `main`
- Feature branches: `feature/[description]`
- All PRs require passing tests before merge

## API Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | `/todos` | List all todos |
| POST | `/todos` | Create a todo |
| GET | `/todos/{id}` | Get a specific todo |
| PUT | `/todos/{id}` | Update a todo |
| DELETE | `/todos/{id}` | Delete a todo |

## Safety Rules

- Never commit the `.env` file or any secrets
- Never modify the database migration files without review
- Always run tests before pushing
- Don't delete production data without explicit confirmation

## Skills Available

| Skill | File | When to Load |
|---|---|---|
| Run Tests | `skills/run_tests.md` | When running or writing tests |
| Deploy | `skills/deploy.md` | When deploying to production |
