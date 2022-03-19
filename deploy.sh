#!/bin/bash
BRANCH=$1

if [ ! -z "$BRANCH" ]; then
	set +v
	echo "# Front-End Checkout: $BRANCH"
	cd Front-End && git checkout "$BRANCH" || exit 1
	echo "# Front-End Pull: $BRANCH"
	git pull && cd .. || exit 1
	
	echo "# Back-End Checkout: $BRANCH"
	cd Back-End && git checkout "$BRANCH" || exit 1
	echo "# Back-End Pull: $BRANCH"
	git pull && cd .. || exit 1
	
	echo "# GIT Add Front-End & Back-End"
	git add Front-End && git add Back-End || exit 1

	echo "# GIT Push"
	git commit -m "Deploy to EC2: $BRANCH" && git push || exit 1
	exit 0
fi

echo "# CONTAINERS"
docker ps

echo
echo "# DOWN..."
docker-compose down --rmi=all --volumes --remove-orphans

echo
echo "# DISK USAGE"
docker system df

echo
echo "# CONTAINERS"
docker container ls

echo
echo "# IMAGE"
docker image ls

echo
echo "# VOLUMES"
docker volume ls

echo
echo "# NETWORKS"
docker network ls

echo
echo "# CONTAINERS"
docker ps

echo
echo "# GIT Config"
git config --global submodule.recurse true
git config --global status.submoduleSummary true

echo
echo "# GIT Status"
git status

echo
echo "# GIT Clean Reset"
git clean -xfd
git submodule foreach --recursive git clean -xfd
git reset --hard
git submodule foreach --recursive git reset --hard
git submodule update --init --recursive

echo
echo "# GIT Pull"
git pull

echo
echo "# GIT Status"
git status

echo
echo "# UP..."
docker-compose up -d

echo
echo "# CONTAINERS"
docker ps
