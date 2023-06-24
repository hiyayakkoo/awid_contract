// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import './IRating.sol';

contract RatingUpdate {
    struct RatingContractInfo {
        address contractAddr;
        bool isEnable;
    }

    RatingContractInfo[] private ratingContracts;

    function updateRatingValue(address winner, address loser) public {
        for (uint256 i = 0; i < ratingContracts.length; i++) {
            if (ratingContracts[i].isEnable) {
                IRating target = IRating(ratingContracts[i].contractAddr);
                target.update(winner, loser);
            }
        }
    }

    function registerRating(address ratingContract) public {
        for (uint256 i = 0; i < ratingContracts.length; i++) {
            if (ratingContracts[i].contractAddr == ratingContract) {
                ratingContracts[i].isEnable = true;
                return;
            }
        }

        ratingContracts.push(RatingContractInfo(ratingContract, true));
    }

    function unregisterRating(address ratingContract) public {
        for (uint256 i = 0; i < ratingContracts.length; i++) {
            if (ratingContracts[i].contractAddr == ratingContract) {
                ratingContracts[i].isEnable = false;
                return;
            }
        }
    }
}
