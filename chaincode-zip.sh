CHAINCODE_NAME_VERSION="chaincodesv1"

# Zip Chaincode
bin/peer lifecycle chaincode package ./channel-artifacts/${CHAINCODE_NAME}.tar.gz --path ./chaincodes/javascript --lang $CHAINCODE_LANG --label $CHAINCODE_NAME_VERSION