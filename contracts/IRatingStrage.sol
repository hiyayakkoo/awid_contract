pragma solidity ^0.8.9;

struct RatingUser {
        address rating;
        uint256 ratingValue;
    }

struct RatingGame {
    address user;
    uint256 ratingValue;
}

interface IRatingStrage {

    function postRating(address rating,address user,uint value) external;

    function getRatingAll(address rating) external returns(RatingUser[] memory);

    function getUserAll(address user) external returns(RatingGame[] memory);

    function getUserRating(address rating,address user) external returns(uint256);
}