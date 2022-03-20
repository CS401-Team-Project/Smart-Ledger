#!/bin/bash

function sep1() {
  echo "==========================================================================================="
}

function sep2() {
  echo "----------------------------------------------------------------------"
}

function cleanreset() {
  sep1
  sep1
  echo "# GIT Config"
  git config --global submodule.recurse true
  git config --global status.submoduleSummary true

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

if [ "$1" == "clean-reset" ]; then
  cleanreset
  exit 0
else
  if [ ! -z "$1" ]; then
    BRANCH=$1
    sep1
    sep1
    set +v
    echo "# Front-End Checkout: $BRANCH"
    cd Front-End && git status && git checkout "$BRANCH" || exit 1
    echo "# Front-End Pull: $BRANCH"
    git pull && git status && cd .. || exit 1

    echo "# Back-End Checkout: $BRANCH"
    cd Back-End && git status && git checkout "$BRANCH" || exit 1
    echo "# Back-End Pull: $BRANCH"
    git pull && git status && cd .. || exit 1

    echo "# GIT Add Front-End & Back-End"
    git add Front-End && git add Back-End || exit 1

    echo "# GIT Push"
    git commit -m "Deploy to EC2: $BRANCH" && git push || exit 1
    set -v
    sep1
    sep1
    exit 0
  fi
fi

function currstate() {
  sep1
  sep1
  echo "# DISK USAGE"
  docker system df

  sep2
  echo "# CONTAINERS"
  docker container ls

  sep2
  echo "# IMAGE"
  docker image ls

  sep2
  echo "# VOLUMES"
  docker volume ls

  sep2
  echo "# NETWORKS"
  docker network ls

  sep2
  echo "# CONTAINERS"
  docker ps

  sep1
  sep1
}

currstate

echo
sep1
sep1
echo "# DOWN..."
docker-compose down --rmi=all --volumes --remove-orphans
sep2
echo "# PRUNE..."
docker system prune -af
sep1
sep1
echo

currstate

echo
sep1
sep1
echo "# UP..."
docker-compose -f docker-compose-prod.yml up -d || exit 1
sep1
sep1

currstate
