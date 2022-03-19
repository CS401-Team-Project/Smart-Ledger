# Smart-Ledger

[![AWS-Deployed](https://github.com/CS401-Team-Project/Smart-Ledger/actions/workflows/deploy-ec2.yml/badge.svg)](https://github.com/CS401-Team-Project/Smart-Ledger/actions/workflows/deploy-ec2.yml)
[![FE-Build](https://github.com/CS401-Team-Project/Front-End/actions/workflows/node.yml/badge.svg)](https://github.com/CS401-Team-Project/Front-End/actions/workflows/node.yml)
[![BE-Pylint](https://github.com/CS401-Team-Project/Back-End/actions/workflows/pylint.yml/badge.svg)](https://github.com/CS401-Team-Project/Back-End/actions/workflows/pylint.yml)

### 1. Requirements

1. Install Docker: https://docs.docker.com/get-docker/
2. Install Docker-Compose: https://docs.docker.com/compose/install/
3. Install Python: https://www.python.org/downloads/

### 2. Useful Git configurations for working with submodules

Enable recursion for relevant commands, such that regular commands recurse into submodules by default (e.g. fetch, pull,
etc.).

```bash
git config --global submodule.recurse true
```

Enable a summary of the submodule status when running `git status`.

```bash
git config --global status.submoduleSummary true
```

Clearer container diffs when referenced submodule commits changed in `git diff`.

```bash
git config --global diff.submodule log
```

Extra: Pretty print commit history with `git lg`.

```bash
git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"
```

[More info on Git Submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules)

### 3. Cloning repository with Front-End and Back-End submodules

```bash
git clone --recurse-submodules --remote-submodules git@github.com:CS401-Team-Project/Smart-Ledger.git
```

Note: The SSH string is preferred if your GitHub account is linked to your machine using an SSH key; otherwise, use the
HTTPS string.

Important: Submodules are always checked out in a detached HEAD state.  
**Make sure to check out the desired branch for both `Front-End` and `Back-End` submodules** (e.g.: `main` or another
development branch).

Either check out the desired branches on each submodule individually with:

```bash
git checkout <branch>
```

or check out the same branch recursively:

```bash
git submodule foreach "git checkout <branch>"
```

### 4. Deployment

### 4.1. Production:
- Uses NGINX reverse proxy to serve static files from the Front-End submodule.
- Front-End - `http://127.0.0.1`
- Back-End (API) - `http://127.0.0.1/api`
- Compose file: `docker-compose-prod.yml`
  - Ex: `docker-compose -f docker-compose-prod.yml up --build ` 

### 4.2. Development:
- Doesn't use NGINX reverse proxy.
- Front-End - `http://127.0.0.1:3000`
- Back-End (API) - `http://127.0.0.1:5000`
- Compose file: `docker-compose.yml`

#### [Helper script](./scripts.py) `scripts.py`:
- Provides a user-friendly interface to perform a sequence of docker-compose commands.
	1. **_Stop and Remove Containers_**
		- _Optionally remove all images, volumes, and orphans._
	2. **_Build/Rebuild_**
	3. **_Create Containers & Start_**
	4. **_Print Logs_**
	5. **_Inspect Containers_**
- Use Space to select 1 or more options, and Enter to confirm.
- Install the module [requirements](./requirements.txt): `pip install -r requirements.txt`

### 4.3. Useful Docker Commands:

1. Build and run the containers:
	- Normal: `docker-compose up`
	- Detached: `docker-compose up -d`
	- More info: https://docs.docker.com/compose/reference/up/
2. If changes are made to the Docker files, you will need to re-build the docker image:
	- Build only: `docker-compose build`
	- Up + rebuild: `docker-compose up --build`
	- Up detached + rebuild: `docker-compose up --build -d`
3. Stop and remove containers and networks for services defined in the Compose file:
	2. `docker-compose down`
	3. Optionally remove images, volumes, and orphans:
		1. Arguments: `--rmi all`, `-v`, `--remove-orphans`
	4. More info: https://docs.docker.com/compose/reference/down/
4. View running containers: `docker-compose ps`
5. Drop into a shell: `docker-compose exec -it <container_name> bash`
6. View logs:
	1. All: `docker-compose logs`
	2. Specific container: `docker-compose logs <container_name>`
