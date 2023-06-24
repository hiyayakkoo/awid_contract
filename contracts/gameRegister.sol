pragma solidity ^0.8.9;

contract GameRegister {

    // gameアドレスとgameDescriptionやgameTitleをmap
    struct gameDescription {
        string title;
        string description;
    }

    mapping ( address => gameDescription ) gameDescriptions;
    mapping ( address => address ) ratingGame;
    mapping ( address => address[] ) gameRating;

    // ratingからgameアドレスを取得する
    function getGameAddress(address ratingAddress) public view returns (string memory){
    }

    // gameアドレスからメタデータを取得する
    function getMetadata(address gameAddress) public view returns (gameDescription memory){
        return gameDescriptions[gameAddress];
    }
    
    // gameアドレスからrating一覧を取得する
    function getEatingAddress(address gameAddress)public {
    }

    // gameを登録する
    function registerGameDiscription(address gameAddress,string calldata description,string calldata title) public {
        gameDescriptions[gameAddress] = gameDescription({title:title,description:description});
    }
}