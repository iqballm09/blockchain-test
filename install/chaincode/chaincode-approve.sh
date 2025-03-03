#!/bin/bash

# Define variables
## Note : Change PACKAGE_ID after chaincode install
VERSION="1"
SEQUENCE="1"
PACKAGE_ID="chaincodesv1:d9ed1218e4821379fe26c1bc888421bac794280962ae07786b741eefb39cf990"
ORDERER_CA="/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/orderer.com/orderers/main.orderer.com/msp/tlscacerts/tlsca.orderer.com-cert.pem"
CORE_PEER_MSPCONFIGPATH_ORG2=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/sl.com/users/Admin@sl.com/msp
CORE_PEER_TLS_ROOTCERT_FILE_ORG2=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/sl.com/users/Admin@sl.com/tls/ca.crt

# Approve Chaincode on peer0.org1Name.example.com Host
docker exec cli peer lifecycle chaincode approveformyorg --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $VERSION --sequence $SEQUENCE --waitForEvent --package-id $PACKAGE_ID

# Approve chaincode on peer0.org2Name.example.com Host
docker exec -e CORE_PEER_MSPCONFIGPATH=$CORE_PEER_MSPCONFIGPATH_ORG2 -e CORE_PEER_ADDRESS=$PEER0_ORG2_CORE_ADDRESS -e CORE_PEER_LOCALMSPID="${ORG2_MSPNAME}" -e CORE_PEER_TLS_ROOTCERT_FILE=$CORE_PEER_TLS_ROOTCERT_FILE_ORG2 cli peer lifecycle chaincode approveformyorg --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $VERSION --sequence $SEQUENCE --waitForEvent --package-id $PACKAGE_ID