pragma solidity ^0.8.9;

import "./IEAS.sol";
import "./ISchemaRegistry.sol";

contract Rating {
    IEAS public eas = IEAS(0xC2679fBD37d54388Ce493F1DB75320D236e1815e);
    bytes32 public SCHEMA_ID = 0x0;// 後でちゃんと作っていれる

    mapping ( address => bytes32 ) private users;

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
}
