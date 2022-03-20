#!/bin/bash

function sep1() {
  echo "==========================================================================================="
}

function sep2() {
  echo "----------------------------------------------------------------------"
}

# Prints out the current state of docker disk usage, containers, images, volumes, and networks
function currstate() {
  sep1
  sep1
  echo "# DOCKER SYSTEM DF (DISK USAGE)"
  docker system df

  sep2
  echo "# DOCKER CONTAINER LS"
  docker container ls

  sep2
  echo "# DOCKER IMAGE LS"
  docker image ls

  sep2
  echo "# DOCKER VOLUME LS"
  docker volume ls

  sep2
  echo "# DOCKER NETWORK LS"
  docker network ls

  sep2
  echo "# DOCKER PS"
  docker ps

  sep1
  sep1
}

# Cleans up the entire repository and submodules, then checks out the main branch
function cleanreset() {
  sep1
  sep1
  echo "# GIT Config"
  git config --global submodule.recurse true
  git config --global status.submoduleSummary true
  git config --global diff.submodule diff

  sep1
  echo "# GIT Status"
  git status

  sep1
  echo "# GIT Clean Reset"
  git clean -xfd
  git submodule foreach --recursive git clean -xfd
  git reset --hard
  git submodule foreach --recursive git reset --hard
  git submodule update --init --recursive

  sep1
  echo "# GIT Checkout Main"
  git checkout main

  sep1
  echo "# GIT Pull"
  git pull

  sep1
  echo "# GIT Status"
  git status

  sep1
  sep1
}


################################################################################
# STEP 1. CLEAN EVERYTHING
################################################################################

# If the first argument is `clean-reset`, run the cleanreset function
if [ "$1" == "clean-reset" ]; then
  cleanreset
  exit 0
fi

################################################################################
# STEP 2. STOP ALL CURRENT CONTAINERS THEN BUILD & START NEW CONTAINERS
################################################################################

currstate

echo ""
sep1
sep1
echo "# DOWN..."
docker-compose down --rmi=all --volumes --remove-orphans
sep2
echo "# PRUNE..."
docker system prune -af
sep1
sep1
echo ""

currstate

echo ""

sep1
sep1
echo "# UP..."
docker-compose -f docker-compose-prod.yml up -d || exit 1
sep1
sep1

currstate
