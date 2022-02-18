#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ] ; then
    echo "./init_db [mongo_admin_username] [mongo_admin_password]"
    exit
fi

echo "## Creating API Mongo User Account"
docker exec -it smart-ledger-api bash -c "python db_scripts/create_api_user.py $1 $2"

# TODO - add example data
