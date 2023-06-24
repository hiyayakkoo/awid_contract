pragma solidity ^0.8.9;

import "./IEAS.sol";
import "./ISchemaRegistry.sol";

contract Rating {
    IEAS public eas = IEAS(0xC2679fBD37d54388Ce493F1DB75320D236e1815e);
    bytes32 public SCHEMA_ID = 0xd942b1ae9506113dd2b9131a092b8d2fb588c08e10a2f3f013a375d8a973e3ea;

    mapping ( address => bytes32 ) private users;

    struct Rating {
        address EOAAddress;
        uint256 ratingValue;
    }

    function addressToBytes32(address _address) private pure returns (bytes32) {
        return bytes32(uint256(uint160(_address)) << 96);
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

    // EASに値を保存する
    function setRatingFor(address user,uint256 ratingValue) private {
        bytes memory rating = convertRatingToBytes(user,ratingValue);

        bytes32 uId = eas.attest(
            AttestationRequest(
                {
                schema: SCHEMA_ID,
                data: AttestationRequestData({
                    recipient: user,
                    expirationTime: 0,
                    revocable: true,
                    data: rating,
                    refUID: addressToBytes32(address(this)),
                    value: 0
                })
            })
        );

        if (users[user] != 0){
            eas.revoke(
                RevocationRequest(
                    {
                        schema: SCHEMA_ID,
                        data: 
                        RevocationRequestData({
                            uid: users[user],
                            value: 0
                        })
                    }
                )
            );
        }

        users[user] = uId;
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
