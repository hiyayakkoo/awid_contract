// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract RatingRegister {

    // logicNameからinit code byteを持ってこれるようなmap
    mapping(string => bytes) public logicToInitCode;

    event ContractCreated(string logicName, address contractAddress);
    event LogicRegistered(string logicName, bytes byteCode);

    function createRating(string memory logicName) public returns (address addr) {
        // logicNameからinit code byteを引いてくる
        bytes memory bytecode = logicToInitCode[logicName];
        require(bytecode.length != 0, "The logic name does not exist");

        // init code byteをしようしてRatingcontractを作る
        bytes32 salt = keccak256(abi.encodePacked(logicName, msg.sender, block.timestamp, block.number));
        address addr;

        assembly {
            addr := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }

        require(addr != address(0), "Contract creation failed");
        emit ContractCreated(logicName, addr);

	return addr;
    }

    // Login nameと、Rating contractを作成するcodeを登録する
    function registerLogic(string memory name, bytes memory byteCode) public {
        logicToInitCode[name] = byteCode;
	emit LogicRegistered(name, byteCode);
    }
}
