#!/bin/bash

docker exec -it sl-mongo bash -c "mongo -u apiuser -p apipassword --authenticationDatabase smart-ledger"