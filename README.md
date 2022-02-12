# Smart-Ledger

### Clone the repository with the Front-End and Back-End submodules

1. To make Git automatically clone submodules, use the following configuration: `git config --global submodule.recurse true`
2. Clone the parent repository: `git clone git@github.com:CS401-Team-Project/Smart-Ledger.git`
	- The SSH string is preferred if your GitHub account is linked to your machine using a SSH key.
	- Otherwise use the HTTPS string.
3. Make sure both `Front-End` and `Back-End` submodules are on the desired branch.
   - Ex: `main` or your development branch.

### Installing Requirements
1. Install Docker: https://docs.docker.com/get-docker/
2. Install Docker-Compose: https://docs.docker.com/compose/install/

### Running the Server
1. Build and run the server in the background as a daemon: `docker-compose up -d`.
2. If changes are made to the Docker files, you will need to re-build the docker image: `docker-compose up --build`. 
