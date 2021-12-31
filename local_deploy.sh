#!/usr/bin/env bash



npx hardhat compile

cp artifacts/contracts/MyEpicNFT.sol/MyEpicNFT.json /Users/Chris.Starling/Documents/aaworkspace/web3-frontend/src/utils/MyEpicNFT.json

npx hardhat run scripts/run.js --network localhost


#echo "output: $output"




