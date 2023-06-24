import { ethers } from "hardhat";

async function main() {
    const RatingRegisterFactory = await ethers.getContractFactory("RatingRegister");
    const ratingRegister = await RatingRegisterFactory.deploy();

    await ratingRegister.waitForDeployment();

    console.log(
        `RatingRegister contract deployed to: ${await ratingRegister.getAddress()}`
    );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
