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

function currstate () {
	echo "====================================================================="
	echo "# DISK USAGE"
	docker system df

	echo
	echo "====================================================================="
	echo "# CONTAINERS"
	docker container ls

	echo
	echo "====================================================================="
	echo "# IMAGE"
	docker image ls

	echo
	echo "====================================================================="
	echo "# VOLUMES"
	docker volume ls

	echo
	echo "====================================================================="
	echo "# NETWORKS"
	docker network ls

	echo
	echo "====================================================================="
	echo "# CONTAINERS"
	docker ps

	echo
	echo "====================================================================="
}

currstate

echo
echo "====================================================================="
echo "# DOWN..."
docker-compose down --rmi=all --volumes --remove-orphans

currstate

echo
echo "====================================================================="
echo "# GIT Config"
git config --global submodule.recurse true
git config --global status.submoduleSummary true

echo
echo "====================================================================="
echo "# GIT Status"
git status

echo
echo "====================================================================="
echo "# GIT Clean Reset"
git clean -xfd
git submodule foreach --recursive git clean -xfd
git reset --hard
git submodule foreach --recursive git reset --hard
git submodule update --init --recursive

echo
echo "====================================================================="
echo "# GIT Checkout Main"
git checkout main

echo
echo "====================================================================="
echo "# GIT Pull"
git pull

echo
echo "====================================================================="
echo "# GIT Status"
git status

echo
echo "====================================================================="
echo "# UP..."
docker-compose up -d || exit 1

echo
echo "====================================================================="
echo "# Volume Prune"
docker volume prune -af

currstate
