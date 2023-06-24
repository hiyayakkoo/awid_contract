import { ethers } from "hardhat";

async function main() {
  const RatingFactory = await ethers.getContractFactory("Rating");
  const rating = await RatingFactory.deploy();

  await rating.waitForDeployment();

  console.log(
      `Rating contract deployed to: ${await rating.getAddress()}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
