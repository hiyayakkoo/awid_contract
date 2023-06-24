// SPDX-License-Identifier: UNLICENSED
// IRating.sol
pragma solidity ^0.8.9;

struct RatingContractInfo {
    address contractAddr;
    bool isEnable;
}

interface IRatingUpdate {
    function getConnectionRatings() view external returns (RatingContractInfo[] memory);
}