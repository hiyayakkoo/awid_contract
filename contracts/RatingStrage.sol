pragma solidity ^0.8.9;

contract RatingStrage {
    struct RatingUser {
        address rating;
        uint256 ratingValue;
    }

    struct RatingGame {
        address user;
        uint256 ratingValue;
    }

    // ratingからユーザー＋レートを出す
    mapping ( address => RatingUser[] ) private gameRatings;
    // rating=>ユーザー=>index
    mapping ( address => mapping(address => uint256) ) private gameIndexe;
    // ユーザーからrating＋レートを出す
    mapping ( address => RatingGame[] ) private userRatings;
    // ユーザー=>rating=>index
    mapping ( address => mapping(address => uint256) ) private userIndexe;

    function postRating(address rating,address user,uint value) public {
        uint256 gameI = gameRatings[rating].length;
        gameIndexe[rating][user] = gameI;
        RatingUser memory game = RatingUser({rating:user,ratingValue:value});
        gameRatings[rating].push(game);
        uint256 userI = gameRatings[user].length;
        gameIndexe[user][rating] = userI;
        RatingUser memory userT = RatingUser({rating:rating,ratingValue:value});
        gameRatings[user].push(userT);
    }

    function getRatingAll(address rating) public view returns (RatingUser[] memory) {
        return gameRatings[rating];
    }

    function getUserAll(address user) public view returns (RatingGame[] memory) {
        return userRatings[user];
    }

    function getUserRating(address rating,address user) public view returns (uint256) {
        return getUserAll(user)[userIndexe[user][rating]].ratingValue;
    }
}