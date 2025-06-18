// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Homework{
    struct Room{
        string name;
        string kind;
        uint256 createTime;
        uint256 result;
    }
    struct Room2{
        string kind;
        uint256 createTime;
        uint256 result;
    }
    struct Room3{
        string name;
        string kind;
        uint256 createTime;
        uint256 result;
    }
    struct Room4{
        bytes32 name;
        bytes32 kind;
        uint256 createTime;
        uint256 result;
    }

    Room[] public rooms;
    mapping(string => Room2) public rooms2;
    mapping(string => Room3) public rooms3;
    Room4[] public rooms4;
    uint256 public roomNumber = 0;

    constructor(){
        
    }

    function init() public{
        rooms.push(Room("first","aaa",block.timestamp,0));
        rooms.push(Room("second","bbb",block.timestamp,0));
        rooms.push(Room("third","ccc",block.timestamp,0));
    }

    function init2() public{
        rooms2["first"] = Room2("aaa",block.timestamp,0);
        rooms2["second"] = Room2("bbb",block.timestamp,0);
        rooms2["third"] = Room2("ccc",block.timestamp,0);
        roomNumber += 1;
    }

    function init3() public{
        rooms3["first"] = Room3("first","aaa",block.timestamp,0);
        rooms3["second"] = Room3("second","bbb",block.timestamp,0);
        rooms3["third"] = Room3("third","ccc",block.timestamp,0);
        roomNumber += 1;
    }

    function init4() public{
        rooms4.push(Room4("first","aaa",block.timestamp,0));
        rooms4.push(Room4("second","bbb",block.timestamp,0));
        rooms4.push(Room4("third","ccc",block.timestamp,0));
    }
    
}