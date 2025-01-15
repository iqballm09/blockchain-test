#!/bin/bash

# Generate genesis block
bin/configtxgen -profile OrdererGenesis -outputBlock ./channel-artifacts/genesis.block -channelID "${SYS_CHANNEL}"
# Generate channel transaction
bin/configtxgen -profile ChannelProfile -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID "${CHANNEL_NAME}"
# Generate MSP
bin/configtxgen -profile ChannelProfile -outputAnchorPeersUpdate "./channel-artifacts/${ORG1_MSPNAME}anchors.tx" -channelID "${CHANNEL_NAME}" -asOrg "${ORG1_MSPNAME}"
bin/configtxgen -profile ChannelProfile -outputAnchorPeersUpdate "./channel-artifacts/${ORG2_MSPNAME}anchors.tx" -channelID "${CHANNEL_NAME}" -asOrg "${ORG2_MSPNAME}"