# Smart-Ledger

### How to clone repository with submodules

1. Automatically clone all submodules: `git config --global submodule.recurse true`
2. Clone the parent repository: `git clone git@github.com:CS401-Team-Project/Smart-Ledger.git` (Preferred if account is linked to your machine using SSH key)
3. Make sure both `Front-End` and `Back-End` submodules are on the desired branch (ex: `main` or your development branch)
4. Run the development environment: `docker-compose up -d`