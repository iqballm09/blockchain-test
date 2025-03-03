CORE_PEER_MSPCONFIGPATH_ORG2=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/sl.com/users/Admin@sl.com/msp
CORE_PEER_TLS_ROOTCERT_FILE_ORG2=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/sl.com/users/Admin@sl.com/tls/ca.crt
CHAINCODE_DIR=./channel-artifacts/chaincodes.tar.gz

# Install chaincodes on peer co host (main)
docker exec cli peer lifecycle chaincode install $CHAINCODE_DIR
# Install chaincodes on peer sl host
docker exec -e CORE_PEER_MSPCONFIGPATH=$CORE_PEER_MSPCONFIGPATH_ORG2 -e CORE_PEER_ADDRESS=${PEER0_ORG2_CORE_ADDRESS} -e CORE_PEER_LOCALMSPID="${ORG2_MSPNAME}" -e CORE_PEER_TLS_ROOTCERT_FILE=$CORE_PEER_TLS_ROOTCERT_FILE_ORG2 cli peer lifecycle chaincode install $CHAINCODE_DIR