import { ethers } from "hardhat";

async function main() {
  const RatingUpdateFactory = await ethers.getContractFactory("RatingUpdate");
  const ratingUpdate = await RatingUpdateFactory.deploy();

  await ratingUpdate.waitForDeployment();

  console.log(
      `RatingUpdate contract deployed to: ${await ratingUpdate.getAddress()}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
