pragma solidity ^0.8.9;

import "./IEAS.sol";
import "./ISchemaRegistry.sol";

contract Rating {
    IEAS public eas = IEAS(0xC2679fBD37d54388Ce493F1DB75320D236e1815e);
    bytes32 public SCHEMA_ID = 0x0;// 後でちゃんと作っていれる

    mapping ( address => bytes32 ) private users;

    struct Rating {
        address EOAAddress;
        uint256 ratingValue;
    }
}
