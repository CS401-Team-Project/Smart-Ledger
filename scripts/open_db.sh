#!/bin/bash

docker exec -it smart-ledger-mongo bash -c "mongo -u apiuser -p apipassword --authenticationDatabase smart-ledger"