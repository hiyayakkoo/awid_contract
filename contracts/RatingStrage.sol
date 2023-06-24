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
        RatingUser memory game = RatingUser({rating:user,ratingValue:value});
        uint256 gameI = gameRatings[rating].length;
        if (gameIndexe[rating][user] == 0){
            gameIndexe[rating][user] = gameI+1;
            gameRatings[rating].push(game);
        }else{
            gameRatings[rating][gameIndexe[rating][user]] = game;
        }

        uint256 userI = gameRatings[user].length;
        RatingUser memory userT = RatingUser({rating:rating,ratingValue:value});
        if (gameIndexe[user][rating] == 0){
            gameRatings[user].push(userT);
            gameIndexe[user][rating] = userI;
        }else{
            gameRatings[user][userIndexe[user][rating]] = userT;
        }
    }

    function getRatingAll(address rating) public view returns (RatingUser[] memory) {
        return gameRatings[rating];
    }

    function getUserAll(address user) public view returns (RatingGame[] memory) {
        return userRatings[user];
    }

    function getUserRating(address rating,address user) public view returns (uint256) {
        if (userIndexe[user][rating] == 0){
            return 0;
        }
        return getUserAll(user)[userIndexe[user][rating]-1].ratingValue;
    }
}