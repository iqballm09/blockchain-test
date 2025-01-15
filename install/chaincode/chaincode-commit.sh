#!/bin/bash

# Define variables
## Note: Version and sequence must be same.
VERSION="1"
SEQUENCE="1"
ORDERER_CA="/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/orderer.com/orderers/main.orderer.com/msp/tlscacerts/tlsca.orderer.com-cert.pem"
PEER0_ORG1_TLS_ROOTCERT="/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/distributor.com/peers/peer0.distributor.com/tls/ca.crt"
PEER0_ORG2_TLS_ROOTCERT="/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/retail.com/peers/peer0.retail.com/tls/ca.crt"
ORDERER_MAIN=orderer.main.com

# Commit chaincode
docker exec cli peer lifecycle chaincode commit -o ${ORDERER_MAIN}:${ORDERER_MAIN_PORT} --tls --cafile $ORDERER_CA \
  --peerAddresses $PEER0_ORG1_CORE_ADDRESS --tlsRootCertFiles $PEER0_ORG1_TLS_ROOTCERT \
  --peerAddresses $PEER0_ORG2_CORE_ADDRESS --tlsRootCertFiles $PEER0_ORG2_TLS_ROOTCERT \
  --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $VERSION --sequence $SEQUENCE
