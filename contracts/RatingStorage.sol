pragma solidity ^0.8.9;

contract RatingStorage {
    struct RatingUser {
        address user;
        uint256 ratingValue;
    }

    struct RatingGame {
        address rating;
        uint256 ratingValue;
    }

    // ratingからユーザー＋レートを出す
    mapping ( address => RatingUser[] ) private gameRatings;
    // rating=>ユーザー=>index
    mapping ( address => mapping(address => uint256) ) private gameIndexes;
    // ユーザーからrating＋レートを出す
    mapping ( address => RatingGame[] ) private userRatings;
    // ユーザー=>rating=>index
    mapping ( address => mapping(address => uint256) ) private userIndexes;

    function postRating(address rating,address user,uint value) public {
        RatingUser memory game = RatingUser({user:user,ratingValue:value});
        RatingGame memory userT = RatingGame({rating:rating,ratingValue:value});

        uint256 gameI = gameRatings[rating].length;
        uint256 userI = userRatings[user].length;

        if (gameIndexes[rating][user] == 0){
            gameIndexes[rating][user] = gameI+1;
            gameRatings[rating].push(game);
        }else{
            gameRatings[rating][gameIndexes[rating][user]-1] = game;
        }
        if (userIndexes[user][rating] == 0){
            userIndexes[user][rating] = userI+1;
            userRatings[user].push(userT);
        }else{
            userRatings[user][userIndexes[user][rating]-1] = userT;
        }
    }

    function getRatingAll(address rating) public view returns (RatingUser[] memory) {
        return gameRatings[rating];
    }

    function getUserAll(address user) public view returns (RatingGame[] memory) {
        return userRatings[user];
    }

    function getUserRating(address rating,address user) public view returns (uint256) {
        if (userIndexes[user][rating] == 0){
            return 0;
        }
        return getUserAll(user)[userIndexes[user][rating]-1].ratingValue;
    }
}