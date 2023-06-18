const main = async () => {
  try {
    const nftContractFactory = await hre.ethers.getContractFactory(
      "UM_ChainBattles"
    );

    const nftContract = await nftContractFactory.deploy();
    await nftContract.deployed();

    console.log("Contract deployed to:", nftContract.address);
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

main();

// 1st Contract deployed to: 0xAF934DA81c2498f579293068731Df8a0F0b1705f (black color)
// 2nd Contract deployed to: 0xe40D6275f0C8511e0D7EA0FD96acd377A90CBf25 (orange color)
// 3rd Contract deployed to: 0x6386Ba50922955AcD6AAC8a7396CABd806697beE (orange color)

// My Challenged Contract Deployed to: 0x620E71Cf8eB9EB3EBb7d3fC7Ed753a6cD5f8AB00 ✔