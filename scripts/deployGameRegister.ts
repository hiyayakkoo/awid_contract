import { ethers } from "hardhat";

async function main() {
    const GameRegisterFactory = await ethers.getContractFactory("GameRegister");
    const gameRegister = await GameRegisterFactory.deploy();

    await gameRegister.waitForDeployment();

    console.log(
        `GameRegister contract deployed to: ${await gameRegister.getAddress()}`
    );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
