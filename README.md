# Smart-Ledger

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

#### 1. **RECOMMENDED**: Use the [Python script](./scripts.py) `script.py`:

- Provides a user-friendly interface to perform a sequence of docker-compose commands.
	1. **_Stop and Remove Containers_**
		- _Optionally remove all images, volumes, and orphans._
	2. **_Build/Rebuild_**
	3. **_Create Containers & Start_**
	4. **_Print Logs_**
	5. **_Inspect Containers_**
- Use Space to select 1 or more options, and Enter to confirm.
- Install the module [requirements](./requirements.txt): `pip install -r requirements.txt`

#### 2. **MANUAL**:

1. Build and run the containers:
	- In the Foreground: `docker-compose up`
	- As a Daemon: `docker-compose up -d`
2. If changes are made to the Docker files, you will need to re-build the docker image:
	- Build only: `docker-compose --build`
	- Build & start: `docker-compose up --build`
	- Build & start as Daemon: `docker-compose up --build -d`
