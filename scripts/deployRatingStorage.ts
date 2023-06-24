import { ethers } from "hardhat";

async function main() {
  const RatingStorageFactory = await ethers.getContractFactory("RatingStorage");
  const ratingStorage = await RatingStorageFactory.deploy();

  await ratingStorage.waitForDeployment();

  console.log(
      `RatingStorage contract deployed to: ${await ratingStorage.getAddress()}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});