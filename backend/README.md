# secure-chat backend

## Getting started

### 1. Install docker

- [Linux](https://docs.docker.com/desktop/setup/install/linux/)
- [Mac](https://docs.docker.com/desktop/setup/install/mac-install/)
- [Windows](https://docs.docker.com/desktop/setup/install/windows-install/)

### 2. Build the containers

```sh
# From the root directory of the repo:
cd backend
docker compose up
# or to start the containers in background:
# docker compose up -d
```

### 3. Create the database

```sh
docker compose exec web bin/rails db:create
docker compose exec web bin/rails db:schema:load
docker compose exec web bin/rails db:seed
```

### 4. Access to the server

By default, the server is located at `http://localhost:3000`.
