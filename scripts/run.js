const hre = require("hardhat");

const main = async () => {
    const nftContractFactory = await hre.ethers.getContractFactory('MyEpicNFT');
    const nftContract = await nftContractFactory.deploy();
    await nftContract.deployed();
    console.log("Contract deployed to:", nftContract.address);
  
    // Call the function.
    let txn = await nftContract.makeAnEpicNFT(2, {
      value: hre.ethers.utils.parseEther('0.002'),
    })
    // Wait for it to be mined.
    await txn.wait()
  
    // Mint another NFT for fun.
    // txn = await nftContract.makeAnEpicNFT()
    // Wait for it to be mined.
    await txn.wait()


    let amountMinted = await nftContract.getAmountMinted();
    console.log("amountMinted:", amountMinted);

    let totalSupply = await nftContract.MAX_SUPPLY();
    console.log("totalSupply:", totalSupply);
  };
  
  const runMain = async () => {
    try {
      await main();
      //process.exit(0);
      setInterval(() => {}, 1 << 30);

    } catch (error) {
      console.log(error);
      process.exit(1);
    }

    console.log("done ");
  };
  
  runMain();