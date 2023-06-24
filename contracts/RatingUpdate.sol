// SPDX-License-Identifier: None
pragma solidity ^0.8.9;

contract RatingUpdate {
    address[] private ratingContracts;

    // ratingに対し計算をさせる
    function updateRatingValue(address winner, address loser) public {
        for (uint i = 0; i < ratingContracts.length; i++) {
        // addressのratingに対して計算を要求する
        }
    }

    // ratingを登録する
    function registerRating(address ratingContract) public {
    }

    // ratingを解除する
    function unregisterRating(address ratingContract) public {
    }
}