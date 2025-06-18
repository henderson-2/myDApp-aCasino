// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Proxy{
    struct Room{
        string name;
        string kind;
        uint256 createTime;
        uint8 result;
    }
    struct Player{
        address id;
        uint128 bet;
        bool odd;
    }
    address public admin;
    address public impl;
    address public token;
    string public name;
    Room[] public rooms;
    uint8 constant maxRooms = 2;
    Player[][] public players;
    uint8 constant maxPlayers = 2;
    mapping(address => uint128) internal chips;


    constructor(address _impl) {
        require(_impl != address(0));
        require(_impl != address(this));
        admin = msg.sender;
        impl = _impl;
    }

    fallback() external payable {
        require(bytes4(msg.data) != bytes4(0));
        (bool success, ) = impl.delegatecall(msg.data);
        require(success, "");
    }

    receive() external payable {}

}