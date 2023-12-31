pragma solidity ^0.8.9;

import "./IRatingUpdate.sol";

contract GameRegister {

    // gameアドレスとgameDescriptionやgameTitleをmap
    struct gameDescription {
        string title;
        string description;
    }

    mapping ( address => gameDescription ) gameDescriptions;
    
    // gameアドレスからrating一覧を取得する
    function getEatingAddress(address gameAddress) view public returns (RatingContractInfo[] memory){
        IRatingUpdate ratingUpdate = IRatingUpdate(gameAddress);
        return ratingUpdate.getConnectionRatings();
    }

    // gameを登録する
    function registerGameDiscription(address gameAddress,string calldata description,string calldata title) public {
        gameDescriptions[gameAddress] = gameDescription({title:title,description:description});
    }

    // gameアドレスからメタデータを取得する
    function getMetadata(address gameAddress) public view returns (gameDescription memory){
        return gameDescriptions[gameAddress];
    }
}