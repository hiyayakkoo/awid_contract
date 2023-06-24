pragma solidity ^0.8.9;

import "./IRatingStorage.sol";

contract Rating {

    IRatingStorage private ratingstorage = IRatingStorage(0x8ABF2979De2FeA109FD20b359AA7a2582339d64e);

    struct Rating {
        address EOAAddress;
        uint256 ratingValue;
    }

    // 基本的にここは外から受け取る他は受け取らない？
    function update(address winner, address loser) public {
        // EASからrating valueの値を取得します
        uint256 winnerRating = getRatingFromEAS(winner);
        uint256 loserRating = getRatingFromEAS(loser);

        // 取得したrating valueの値を再計算します
        (uint256 newWinnerRating, uint256 newLoserRating) = recalculateRatings(winnerRating, loserRating);

        // 計算後のrating valueを格納します
        setRatingFor(winner, newWinnerRating);
        setRatingFor(loser, newLoserRating);
    }

    // EASから値を取得する
    function getRatingFromEAS(address userAddress) private view returns(uint256) {
        if (ratingstorage.getUserRating(address(this), userAddress) == 0){
            return 1500;
        }
        return ratingstorage.getUserRating(address(this), userAddress);
    }

    // EASに値を保存する
    function setRatingFor(address user,uint256 ratingValue) private {
        ratingstorage.postRating(address(this), user, ratingValue);
    }

    // ratingを計算する
    function recalculateRatings(uint256 winnerRating,uint256 loserRating) public view returns(uint256,uint256){
        // ↓フロントエンドでの実装時はここに入力される
        // 現在はeloratingの実装
        int256 ratingDifference = int256(winnerRating) - int256(loserRating);
        uint256 myChanceToWin = 32 - uint256((ratingDifference * 32) / 400);

        if (winnerRating + myChanceToWin > winnerRating) {
            winnerRating += myChanceToWin;
        } else {
            winnerRating = type(uint256).max;
        }
        
        if (loserRating > myChanceToWin) {
            loserRating -= myChanceToWin;
        } else {
            loserRating = 0;
        }

        return (winnerRating, loserRating);
        // 現在はeloratingの実装
        // ↑フロントエンドでの実装時はここに入力される
    }
}
