pragma solidity ^0.8.9;

import "./IRatingStorage.sol";
import "./IEAS.sol";
import "./ISchemaRegistry.sol";


contract Rating {

    IRatingStorage private ratingstorage = IRatingStorage(0x8ABF2979De2FeA109FD20b359AA7a2582339d64e);

    // About eas 
    IEAS public eas = IEAS(0xC2679fBD37d54388Ce493F1DB75320D236e1815e);
    bytes32 public SCHEMA_ID = 0x20ca2425687955822f30d1ac5b10992477298abd6f10e5e14c493025395056d6;
    mapping ( address => bytes32 ) private easUsers;

    struct Rating {
        uint256 ratingValue;
        address EOAAddress;
    }

    event RatingUpdated(address userAddress, address attester, uint256 newRating);

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

    function convertRatingToBytes(address user, uint256 ratingValue) public pure returns (bytes memory) {
        Rating memory rating = Rating({ratingValue: ratingValue, EOAAddress: user}); // 順番守る必要ある
        bytes memory ratingBytes = abi.encode(rating);
        return ratingBytes;
    }

    // EASから値を取得する
    function getRatingFromEAS(address userAddress) private view returns(uint256) {
        if (ratingstorage.getUserRating(address(this), userAddress) == 0){
            return 1500;
        }
        return ratingstorage.getUserRating(address(this), userAddress);
    }

    // EASに値を保存する
    function setRatingFor(address user,uint256 ratingValue) public {
        ratingstorage.postRating(address(this), user, ratingValue);

        // Eas
        bytes memory rating = convertRatingToBytes(user,ratingValue);

        bytes32 uId = eas.attest(
            AttestationRequest(
                {
                schema: SCHEMA_ID,
                data: AttestationRequestData({
                    recipient: address(user),
                    expirationTime: uint64(0),
                    revocable: false,
                    refUID: bytes32(0x0000000000000000000000000000000000000000000000000000000000000000),
                    data: rating,
                    value: uint256(0)
                })
            })
        );

        emit RatingUpdated(user, address(this), ratingValue);

        // TODO: revoke→最悪やらなくても良い
        // if (easUsers[user] != 0){
        //     eas.revoke(
        //         RevocationRequest(
        //             {
        //                 schema: SCHEMA_ID,
        //                 data: 
        //                 RevocationRequestData({
        //                     uid: easUsers[user],
        //                     value: 0
        //                 })
        //             }
        //         )
        //     );
        // }

        // easUsers[user] = uId;
    }

    // ratingを計算する
    function recalculateRatings(uint256 winnerRating,uint256 loserRating) public view returns(uint256,uint256){
        // ↓フロントエンドでの実装時はここに入力される
        // 現在はeloratingの実装
        int256 ratingDifference = int256(winnerRating) - int256(loserRating);
        int256 myChanceToWin = 32 - ((ratingDifference * 32) / 400);
        
        if (myChanceToWin > 31) {
            myChanceToWin = 31;
        } else if (myChanceToWin < 1) {
            myChanceToWin = 1;
        }
        
        if (winnerRating + uint256(myChanceToWin) > winnerRating) {
            winnerRating += uint256(myChanceToWin);
        } else {
            winnerRating = type(uint256).max;
        }
        
        if (loserRating > uint256(myChanceToWin)) {
            loserRating -= uint256(myChanceToWin);
        } else {
            loserRating = 0;
        }

        return (winnerRating, loserRating);
        // 現在はeloratingの実装
        // ↑フロントエンドでの実装時はここに入力される
    }
}
