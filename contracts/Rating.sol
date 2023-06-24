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

    // ユーティリティ
    function convertBytesToRating(bytes memory ratingBytes) public pure returns (address, uint256) {
        (Rating memory rating) = abi.decode(ratingBytes, (Rating));
        return (rating.EOAAddress, rating.ratingValue);
    }

    function convertRatingToBytes(address user, uint256 ratingValue) public pure returns (bytes memory) {
        Rating memory rating = Rating({EOAAddress: user, ratingValue: ratingValue});
        bytes memory ratingBytes = abi.encode(rating);
        return ratingBytes;
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
        if (users[userAddress] == 0){
            return 1500;
        }
        Attestation memory rating = eas.getAttestation(users[userAddress]);
        (address user, uint256 ratingValue) = convertBytesToRating(rating.data);
        return ratingValue;
    }
}
