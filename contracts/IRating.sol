// SPDX-License-Identifier: UNLICENSED
// IRating.sol
pragma solidity ^0.8.9;

interface IRating {
    function update(address winner, address loser) external;
}