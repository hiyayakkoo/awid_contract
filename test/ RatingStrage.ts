import { ethers } from "hardhat";
import { expect } from "chai";

describe("RatingStorage", () => {
    let ratingStorage :any;

    beforeEach(async () => {

        const RatingUpdateContract:any = await ethers.getContractFactory("RatingStorage");
        ratingStorage = await RatingUpdateContract.deploy();
    });

    it("Should post a rating strage", async () => {
        const [firstPlayer, secondPlayer] = await ethers.getSigners()
        const [firstGame, secondGame] = await ethers.getSigners()
        await ratingStorage.postRating(firstGame.address,firstPlayer.address,1501)
        await ratingStorage.postRating(secondGame.address,firstPlayer.address,1502)
        await ratingStorage.postRating(firstGame.address,secondPlayer.address,1502)

        const firstGameRating = await ratingStorage.getRatingAll(firstGame.address);
        const secondGameRating = await ratingStorage.getRatingAll(secondGame.address);

        expect(firstGameRating[0][0]).to.equal(firstPlayer.address);
        expect(firstGameRating[0][1]).to.equal(1501);
        expect(firstGameRating[1][0]).to.equal(secondPlayer.address);
        expect(firstGameRating[1][1]).to.equal(1502);
        expect(secondGameRating[0][0]).to.equal(firstPlayer.address);
        expect(secondGameRating[0][1]).to.equal(1502);


        const firstPlayerRating = await ratingStorage.getUserAll(firstPlayer.address);
        let secondPlayerRating = await ratingStorage.getUserAll(secondPlayer.address);
        expect(firstPlayerRating[0][0]).to.equal(firstGame.address);
        expect(firstPlayerRating[0][1]).to.equal(1501);
        expect(firstPlayerRating[1][0]).to.equal(secondGame.address);
        expect(firstPlayerRating[1][1]).to.equal(1502);
        expect(secondPlayerRating[0][0]).to.equal(firstGame.address);
        expect(secondPlayerRating[0][1]).to.equal(1502);



        let rating = await ratingStorage.getUserRating(firstPlayer.address,firstGame.address);
        expect(rating).to.equal(1501);

        await ratingStorage.postRating(firstGame.address,secondPlayer.address,1500)
        rating = await ratingStorage.getUserRating(firstGame.address,secondPlayer.address);
        expect(rating).to.equal(1500);
    });
});