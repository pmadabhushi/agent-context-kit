# SKILL: Deploy

**Skill ID:** deploy
**Trigger:** User asks to deploy, push to production, or release

## Prerequisites

- [ ] All tests pass (`pytest tests/ -v`)
- [ ] Changes are committed and pushed to `main`
- [ ] No pending database migrations that haven't been tested

## Steps

1. Confirm all tests pass: `pytest tests/ -v`
2. Build the Docker image: `docker build -t todo-app .`
3. Tag the image: `docker tag todo-app todo-app:v[VERSION]`
4. Push to registry: `docker push todo-app:v[VERSION]`
5. SSH to server and pull new image
6. Restart the container: `docker compose up -d`
7. Verify the app is running: `curl https://your-domain.com/todos`

## Output Format

```
Deployment Summary
------------------
Version:     [version]
Status:      [Success/Failed]
Health Check:[Pass/Fail]
Rollback:    docker compose up -d --force-recreate (previous image)
```
