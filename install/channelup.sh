ORDERER_MAIN=orderer.main.com
ORDERER_TLSCACERTS=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/orderer.com/orderers/main.orderer.com/msp/tlscacerts/tlsca.orderer.com-cert.pem
ORG2_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/retail.com/users/Admin@retail.com/msp
ORG2_TLS_ROOTCERT=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/retail.com/users/Admin@retail.com/tls/ca.crt

# Create channel
docker exec cli peer channel create -o ${ORDERER_MAIN}:${ORDERER_MAIN_PORT} -c ${CHANNEL_NAME} -f ./channel-artifacts/channel.tx --outputBlock ./channel-artifacts/${CHANNEL_NAME}.block --tls --cafile $ORDERER_TLSCACERTS

sleep 5

# menambahkan peer distributor ke dalam channel
docker exec cli peer channel join -b ./channel-artifacts/${CHANNEL_NAME}.block
# update peer distributor 
docker exec cli peer channel update -o ${ORDERER_MAIN}:${ORDERER_MAIN_PORT} -c ${CHANNEL_NAME} -f ./channel-artifacts/${ORG1_MSPNAME}anchors.tx --tls --cafile $ORDERER_TLSCACERTS

# menambahkan peer retail ke dalam channel
docker exec -e CORE_PEER_MSPCONFIGPATH=$ORG2_MSPCONFIGPATH -e CORE_PEER_ADDRESS=${PEER0_ORG2_CORE_ADDRESS} -e CORE_PEER_LOCALMSPID="${ORG2_MSPNAME}" -e CORE_PEER_TLS_ROOTCERT_FILE=$ORG2_TLS_ROOTCERT cli peer channel join -b ./channel-artifacts/${CHANNEL_NAME}.block
# update peer retail
docker exec -e CORE_PEER_MSPCONFIGPATH=$ORG2_MSPCONFIGPATH -e CORE_PEER_ADDRESS=${PEER0_ORG2_CORE_ADDRESS} -e CORE_PEER_LOCALMSPID="${ORG2_MSPNAME}" -e CORE_PEER_TLS_ROOTCERT_FILE=$ORG2_TLS_ROOTCERT cli peer channel update -o ${ORDERER_MAIN}:${ORDERER_MAIN_PORT} -c ${CHANNEL_NAME} -f ./channel-artifacts/${ORG2_MSPNAME}anchors.tx --tls --cafile $ORDERER_TLSCACERTS