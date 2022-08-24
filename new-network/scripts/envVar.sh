#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# This is a collection of bash functions used by different scripts

# imports
. scripts/utils.sh

export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/upstac.com/orderers/orderer.upstac.com/msp/tlscacerts/tlsca.upstac.com-cert.pem
export PEER0_HOSPITALA_CA=${PWD}/organizations/peerOrganizations/hospitalA.upstac.com/peers/peer0.hospitalA.upstac.com/tls/ca.crt
export PEER0_HOSPITALB_CA=${PWD}/organizations/peerOrganizations/hospitalB.upstac.com/peers/peer0.hospitalB.upstac.com/tls/ca.crt
export PEER0_GOVERNMENT_CA=${PWD}/organizations/peerOrganizations/government.upstac.com/peers/peer0.government.upstac.com/tls/ca.crt
export PEER0_ORG3_CA=${PWD}/organizations/peerOrganizations/org3.upstac.com/peers/peer0.org3.upstac.com/tls/ca.crt

# Set environment variables for the peer org
setGlobals() {
  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  infoln "Using organization ${USING_ORG}"
  if [ $USING_ORG == "hospitalA" ]; then
    export CORE_PEER_LOCALMSPID="HospitalAMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_HOSPITALA_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/hospitalA.upstac.com/users/Admin@hospitalA.upstac.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
  elif [ $USING_ORG == "hospitalB" ]; then
    export CORE_PEER_LOCALMSPID="HospitalBMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_HOSPITALB_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/hospitalB.upstac.com/users/Admin@hospitalB.upstac.com/msp
    export CORE_PEER_ADDRESS=localhost:9051
  elif [ $USING_ORG == "government" ]; then
    export CORE_PEER_LOCALMSPID="GovernmentMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_GOVERNMENT_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/government.upstac.com/users/Admin@government.upstac.com/msp
    export CORE_PEER_ADDRESS=localhost:11051

  elif [ $USING_ORG -eq 3 ]; then
    export CORE_PEER_LOCALMSPID="Org3MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG3_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org3.upstac.com/users/Admin@org3.upstac.com/msp
    export CORE_PEER_ADDRESS=localhost:13051
  else
    errorln "ORG Unknown"
  fi

  if [ "$VERBOSE" == "true" ]; then
    env | grep CORE
  fi
}

# Set environment variables for use in the CLI container
setGlobalsCLI() {
  setGlobals $1

  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  if [ $USING_ORG == "hospitalA" ]; then
    export CORE_PEER_ADDRESS=peer0.hospitalA.upstac.com:7051
  elif [ $USING_ORG == "hospitalB" ]; then
    export CORE_PEER_ADDRESS=peer0.hospitalB.upstac.com:9051
  elif [ $USING_ORG == "government" ]; then
    export CORE_PEER_ADDRESS=peer0.government.upstac.com:11051
  elif [ $USING_ORG -eq 3 ]; then
    export CORE_PEER_ADDRESS=peer0.org3.upstac.com:13051
  else
    errorln "ORG Unknown"
  fi
}

# parsePeerConnectionParameters $@
# Helper function that sets the peer connection parameters for a chaincode
# operation
parsePeerConnectionParameters() {
  PEER_CONN_PARMS=""
  PEERS=""
  while [ "$#" -gt 0 ]; do
    setGlobals $1
    PEER="peer0.$1"
    ## Set peer addresses
    PEERS="$PEERS $PEER"
    PEER_CONN_PARMS="$PEER_CONN_PARMS --peerAddresses $CORE_PEER_ADDRESS"
    ## Set path to TLS certificate
    if [ $1 == "hospitalA" ]; then
      TLSINFO=$(eval echo "--tlsRootCertFiles \$PEER0_HOSPITALA_CA")
    elif [ $1 == "hospitalB" ]; then
      TLSINFO=$(eval echo "--tlsRootCertFiles \$PEER0_HOSPITALB_CA")
    elif [ $1 == "government" ]; then
      TLSINFO=$(eval echo "--tlsRootCertFiles \$PEER0_GOVERNMENT_CA")
    else
      TLSINFO=$(eval echo "--tlsRootCertFiles \$PEER0_$1_CA")
    fi
    PEER_CONN_PARMS="$PEER_CONN_PARMS $TLSINFO"
    # shift by one to get to the next organization
    shift
  done
  # remove leading space for output
  PEERS="$(echo -e "$PEERS" | sed -e 's/^[[:space:]]*//')"
}

verifyResult() {
  if [ $1 -ne 0 ]; then
    fatalln "$2"
  fi
}
