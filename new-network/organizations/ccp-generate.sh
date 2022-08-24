#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.json
}

function yaml_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
}

ORG=hospitalA
P0PORT=7051
CAPORT=7054
PEERPEM=organizations/peerOrganizations/hospitalA.upstac.com/tlsca/tlsca.hospitalA.upstac.com-cert.pem
CAPEM=organizations/peerOrganizations/hospitalA.upstac.com/ca/ca.hospitalA.upstac.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/hospitalA.upstac.com/connection-hospitalA.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/hospitalA.upstac.com/connection-hospitalA.yaml

ORG=hospitalB
P0PORT=9051
CAPORT=8054
PEERPEM=organizations/peerOrganizations/hospitalB.upstac.com/tlsca/tlsca.hospitalB.upstac.com-cert.pem
CAPEM=organizations/peerOrganizations/hospitalB.upstac.com/ca/ca.hospitalB.upstac.com-cert.pem

ORG=government
P0PORT=11051
CAPORT=9054
PEERPEM=organizations/peerOrganizations/government.upstac.com/tlsca/tlsca.government.upstac.com-cert.pem
CAPEM=organizations/peerOrganizations/government.upstac.com/ca/ca.government.upstac.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/government.upstac.com/connection-government.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/government.upstac.com/connection-government.yaml
