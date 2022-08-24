#!/bin/bash

function createHospitalA() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/hospitalA.upstac.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/hospitalA.upstac.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-hospitalA --tls.certfiles ${PWD}/organizations/fabric-ca/hospitalA/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-hospitalA.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-hospitalA.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-hospitalA.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-hospitalA.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/hospitalA.upstac.com/msp/config.yaml

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-hospitalA --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/hospitalA/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-hospitalA --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/hospitalA/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-hospitalA --id.name hospitalAadmin --id.secret hospitalAadminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/hospitalA/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-hospitalA -M ${PWD}/organizations/peerOrganizations/hospitalA.upstac.com/peers/peer0.hospitalA.upstac.com/msp --csr.hosts peer0.hospitalA.upstac.com --tls.certfiles ${PWD}/organizations/fabric-ca/hospitalA/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/hospitalA.upstac.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/hospitalA.upstac.com/peers/peer0.hospitalA.upstac.com/msp/config.yaml

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-hospitalA -M ${PWD}/organizations/peerOrganizations/hospitalA.upstac.com/peers/peer0.hospitalA.upstac.com/tls --enrollment.profile tls --csr.hosts peer0.hospitalA.upstac.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/hospitalA/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/hospitalA.upstac.com/peers/peer0.hospitalA.upstac.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/hospitalA.upstac.com/peers/peer0.hospitalA.upstac.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/hospitalA.upstac.com/peers/peer0.hospitalA.upstac.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/hospitalA.upstac.com/peers/peer0.hospitalA.upstac.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/hospitalA.upstac.com/peers/peer0.hospitalA.upstac.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/hospitalA.upstac.com/peers/peer0.hospitalA.upstac.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/hospitalA.upstac.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/hospitalA.upstac.com/peers/peer0.hospitalA.upstac.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/hospitalA.upstac.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/hospitalA.upstac.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/hospitalA.upstac.com/peers/peer0.hospitalA.upstac.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/hospitalA.upstac.com/tlsca/tlsca.hospitalA.upstac.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/hospitalA.upstac.com/ca
  cp ${PWD}/organizations/peerOrganizations/hospitalA.upstac.com/peers/peer0.hospitalA.upstac.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/hospitalA.upstac.com/ca/ca.hospitalA.upstac.com-cert.pem

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-hospitalA -M ${PWD}/organizations/peerOrganizations/hospitalA.upstac.com/users/User1@hospitalA.upstac.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/hospitalA/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/hospitalA.upstac.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/hospitalA.upstac.com/users/User1@hospitalA.upstac.com/msp/config.yaml

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://hospitalAadmin:hpospitalAadminpw@localhost:7054 --caname ca-hospitalA -M ${PWD}/organizations/peerOrganizations/hospitalA.upstac.com/users/Admin@hospitalA.upstac.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/hospitalA/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/hospitalA.upstac.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/hospitalA.upstac.com/users/Admin@hospitalA.upstac.com/msp/config.yaml
}

function createHospitalB() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/hospitalB.upstac.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/hospitalB.upstac.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-hospitalB --tls.certfiles ${PWD}/organizations/fabric-ca/hospitalB/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-hospitalB.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-hospitalB.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-hospitalB.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-hospitalB.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/hospitalB.upstac.com/msp/config.yaml

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-hospitalB --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/hospitalB/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-hospitalB --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/hospitalB/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-hospitalB --id.name hospitalBadmin --id.secret hospitalBadminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/hospitalB/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-hospitalB -M ${PWD}/organizations/peerOrganizations/hospitalB.upstac.com/peers/peer0.hospitalB.upstac.com/msp --csr.hosts peer0.hospitalB.upstac.com --tls.certfiles ${PWD}/organizations/fabric-ca/hospitalB/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/hospitalB.upstac.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/hospitalB.upstac.com/peers/peer0.hospitalB.upstac.com/msp/config.yaml

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-hospitalB -M ${PWD}/organizations/peerOrganizations/hospitalB.upstac.com/peers/peer0.hospitalB.upstac.com/tls --enrollment.profile tls --csr.hosts peer0.hospitalB.upstac.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/hospitalB/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/hospitalB.upstac.com/peers/peer0.hospitalB.upstac.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/hospitalB.upstac.com/peers/peer0.hospitalB.upstac.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/hospitalB.upstac.com/peers/peer0.hospitalB.upstac.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/hospitalB.upstac.com/peers/peer0.hospitalB.upstac.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/hospitalB.upstac.com/peers/peer0.hospitalB.upstac.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/hospitalB.upstac.com/peers/peer0.hospitalB.upstac.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/hospitalB.upstac.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/hospitalB.upstac.com/peers/peer0.hospitalB.upstac.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/hospitalB.upstac.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/hospitalB.upstac.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/hospitalB.upstac.com/peers/peer0.hospitalB.upstac.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/hospitalB.upstac.com/tlsca/tlsca.hospitalB.upstac.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/hospitalB.upstac.com/ca
  cp ${PWD}/organizations/peerOrganizations/hospitalB.upstac.com/peers/peer0.hospitalB.upstac.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/hospitalB.upstac.com/ca/ca.hospitalB.upstac.com-cert.pem

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-hospitalB -M ${PWD}/organizations/peerOrganizations/hospitalB.upstac.com/users/User1@hospitalB.upstac.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/hospitalB/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/hospitalB.upstac.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/hospitalB.upstac.com/users/User1@hospitalB.upstac.com/msp/config.yaml

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://hospitalBadmin:hospitalBadminpw@localhost:8054 --caname ca-hospitalB -M ${PWD}/organizations/peerOrganizations/hospitalB.upstac.com/users/Admin@hospitalB.upstac.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/hospitalB/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/hospitalB.upstac.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/hospitalB.upstac.com/users/Admin@hospitalB.upstac.com/msp/config.yaml
}

function createGovernment() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/government.upstac.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/government.upstac.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-government --tls.certfiles ${PWD}/organizations/fabric-ca/government/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-government.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-government.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-government.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-government.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/government.upstac.com/msp/config.yaml

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-government --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/government/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-government --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/government/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-government --id.name governmentadmin --id.secret governmentadminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/government/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:9054 --caname ca-government -M ${PWD}/organizations/peerOrganizations/government.upstac.com/peers/peer0.government.upstac.com/msp --csr.hosts peer0.government.upstac.com --tls.certfiles ${PWD}/organizations/fabric-ca/government/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/government.upstac.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/government.upstac.com/peers/peer0.government.upstac.com/msp/config.yaml

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:9054 --caname ca-government -M ${PWD}/organizations/peerOrganizations/government.upstac.com/peers/peer0.government.upstac.com/tls --enrollment.profile tls --csr.hosts peer0.government.upstac.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/government/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/government.upstac.com/peers/peer0.government.upstac.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/government.upstac.com/peers/peer0.government.upstac.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/government.upstac.com/peers/peer0.government.upstac.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/government.upstac.com/peers/peer0.government.upstac.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/government.upstac.com/peers/peer0.government.upstac.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/government.upstac.com/peers/peer0.government.upstac.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/government.upstac.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/government.upstac.com/peers/peer0.government.upstac.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/government.upstac.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/government.upstac.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/government.upstac.com/peers/peer0.government.upstac.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/government.upstac.com/tlsca/tlsca.government.upstac.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/government.upstac.com/ca
  cp ${PWD}/organizations/peerOrganizations/government.upstac.com/peers/peer0.government.upstac.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/government.upstac.com/ca/ca.government.upstac.com-cert.pem

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:9054 --caname ca-government -M ${PWD}/organizations/peerOrganizations/government.upstac.com/users/User1@government.upstac.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/government/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/government.upstac.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/government.upstac.com/users/User1@government.upstac.com/msp/config.yaml

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://hospitalBadmin:hospitalBadminpw@localhost:9054 --caname ca-government -M ${PWD}/organizations/peerOrganizations/government.upstac.com/users/Admin@government.upstac.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/government/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/government.upstac.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/government.upstac.com/users/Admin@government.upstac.com/msp/config.yaml
}

function createOrderer() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/ordererOrganizations/upstac.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/upstac.com

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:10054 --caname ca-orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/ordererOrganizations/upstac.com/msp/config.yaml

  infoln "Registering orderer"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the orderer admin"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the orderer msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/upstac.com/orderers/orderer.upstac.com/msp --csr.hosts orderer.upstac.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/upstac.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/upstac.com/orderers/orderer.upstac.com/msp/config.yaml

  infoln "Generating the orderer-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/upstac.com/orderers/orderer.upstac.com/tls --enrollment.profile tls --csr.hosts orderer.upstac.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/upstac.com/orderers/orderer.upstac.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/upstac.com/orderers/orderer.upstac.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/upstac.com/orderers/orderer.upstac.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/upstac.com/orderers/orderer.upstac.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/upstac.com/orderers/orderer.upstac.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/upstac.com/orderers/orderer.upstac.com/tls/server.key

  mkdir -p ${PWD}/organizations/ordererOrganizations/upstac.com/orderers/orderer.upstac.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/upstac.com/orderers/orderer.upstac.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/upstac.com/orderers/orderer.upstac.com/msp/tlscacerts/tlsca.upstac.com-cert.pem

  mkdir -p ${PWD}/organizations/ordererOrganizations/upstac.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/upstac.com/orderers/orderer.upstac.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/upstac.com/msp/tlscacerts/tlsca.upstac.com-cert.pem

  infoln "Generating the admin msp"
  set -x
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/upstac.com/users/Admin@upstac.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/upstac.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/upstac.com/users/Admin@upstac.com/msp/config.yaml
}
