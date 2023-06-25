// registerRating.js
const { ethers } = require("hardhat");

async function main() {
    // Get the signer to send the transactions
    const signer = (await ethers.getSigners())[0];

    // Get an instance of the deployed RatingUpdate contract
    const ratingRegister = await ethers.getContractAt("RatingRegister", "0x490DDb507C77e467F6C572C765CA0861bbDA0aA6", signer);
    console.log("!Creating the rating contract...");
    const tx = await ratingRegister.createRating("Elorating")
    console.log("Transaction Hash:", tx.hash);
    console.log(await tx.wait()); // Wait for the transaction to be mined

    console.log("Rating contract registered successfully.");
    console.log(tx)
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
