const { ethers } = require("hardhat");

async function main(RATING_ADDRESS, RATING_UPDATE_ADDRESS) {
    // Get the signer to send the transactions
    const signer = (await ethers.getSigners())[0];

    // Get an instance of the deployed RatingUpdate contract
    const RatingUpdate = await ethers.getContractAt("RatingUpdate", RATING_UPDATE_ADDRESS, signer);

    // Call registerRating() using the Rating contract address
    console.log("Registering the rating contract...");
    const tx = await RatingUpdate.registerRating(RATING_ADDRESS);
    await tx.wait(); // Wait for the transaction to be mined

    console.log("Rating contract registered successfully.");
}

const RATING_ADDRESS = process.env.RATING_ADDRESS;
const RATING_UPDATE_ADDRESS = process.env.RATING_UPDATE_ADDRESS;

main(RATING_ADDRESS, RATING_UPDATE_ADDRESS)
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
