#!/bin/bash

echo
echo " ____    _____      _      ____    _____ "
echo "/ ___|  |_   _|    / \    |  _ \  |_   _|"
echo "\___ \    | |     / _ \   | |_) |   | |  "
echo " ___) |   | |    / ___ \  |  _ <    | |  "
echo "|____/    |_|   /_/   \_\ |_| \_\   |_|  "
echo
echo "Deploying Chaincode On Upstac Network"
echo
CHANNEL_NAME="$1"
DELAY="$2"
LANGUAGE="$3"
VERSION="$4"
TYPE="$5"
: ${CHANNEL_NAME:="common"}
: ${DELAY:="5"}
: ${LANGUAGE:="node"}
: ${VERSION:=1.1}
: ${TYPE="basic"}

LANGUAGE=`echo "$LANGUAGE" | tr [:upper:] [:lower:]`
ORGS="hospitalA hospitalB government"
TIMEOUT=15
COUNTER=1
MAX_RETRY=20
PACKAGE_ID=""
CC_RUNTIME_LANGUAGE="node"
CC_SRC_PATH="/opt/gopath/src/github.com/hyperledger/fabric/peer/chaincode/"


echo "Channel name : "$CHANNEL_NAME

# import utils
. scripts/utils.sh


## at first we package the chaincode
echo "Packaging chaincode on peer0.hospitalA.upstac.com ..."
packageChaincode $VERSION 0 'hospitalA'

## Install new version of chaincode on peer0 of all 3 orgs making them endorsers
echo "Installing chaincode on peer0.hospitalA.upstac.com ..."
installChaincode 0 'hospitalA'
echo "Installing chaincode on peer0.hospitalB.upstac.com ..."
installChaincode 0 'hospitalB'
echo "Installing chaincode on peer0.government.upstac.com ..."
installChaincode 0 'government'

## Query whether the chaincode is installed for hospitalA - peer0
queryInstalled 0 'hospitalA'
## Approve the definition for hospitalA - peer0
approveForMyOrg $VERSION 0 'hospitalA'
## Query whether the chaincode is installed for hospitalB - peer0
queryInstalled 0 'hospitalB'
## Approve the definition for hospitalB - peer0
approveForMyOrg $VERSION 0 'hospitalB'
## Query whether the chaincode is installed for government - peer0
queryInstalled 0 'government'
## Approve the definition for government - peer0
approveForMyOrg $VERSION 0 'government'

## now that all orgs have approved the definition, commit the definition
echo "Committing chaincode definition on channel after getting approval from majority orgs..."
commitChaincodeDefinition $VERSION 0 'hospitalA' 0 'hospitalB' 0 'government'

## Invoke chaincode first time with --isInit flag to instantiate the chaincode
echo "Invoking chaincode with --isInit flag to instantiate the chaincode on channel..."
chaincodeInvoke 0 'hospitalA' 0 'hospitalB' 0 'government'

echo
echo "========= All GOOD, Chaincode Is Now Installed & Instantiated On Network =========== "
echo

echo
echo " _____   _   _   ____   "
echo "| ____| | \ | | |  _ \  "
echo "|  _|   |  \| | | | | | "
echo "| |___  | |\  | | |_| | "
echo "|_____| |_| \_| |____/  "
echo

exit 0
