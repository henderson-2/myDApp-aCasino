// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {Ichip} from "./tokenization/Ichip.sol";

contract Implementation{
    using SafeERC20 for IERC20;
    struct Room{
        string name;
        string kind;
        uint256 createTime;
        uint256 endTime;
        uint256 result;
    }
    struct Player{
        address id;
        uint128 bet;
        bool odd;
    }
    event roomIsClosed(uint256 index);
    address public admin;
    address public impl;
    address public token;
    Room[] public rooms;
    uint256 constant maxRooms = 2;
    Player[][] public players;
    uint256 constant maxPlayers = 2;
    mapping(address => uint256) internal chips;
    mapping(address => bool) internal isInRoom;//用户是否在任意一个房间中，原则上规定用户一次只能进入一个房间

    constructor(){
        admin = msg.sender;
    }

    function setToken(address _token) external{
        token = _token;
    }

    function updateImpl(address _newimpl) external{
        console.log(msg.sender);
        require(msg.sender == admin);
        require(_newimpl != address(0));
        require(_newimpl != address(this));
        impl = _newimpl;
    }

    function sit(string memory roomName, string memory kind, bool choice, uint128 amount) external{
        require(amount > 0, "you need to bet something");
        (bool newRoom, uint256 index) = checkRoom(roomName);
        if(newRoom){//房间是否已存在
            require(rooms.length < maxRooms, "the number of rooms is max now");//房间数有无超上限
            rooms.push(Room(roomName, kind, block.timestamp, 0, 0));//创建房间
            players.push();//初始化房间玩家
        }
        console.log("one", index);
        if(!newRoom) require(players[index].length < maxPlayers, "room is full");//房间不是新建的，检查房间人数是否已达上限
        console.log("two");
        require(isInRoom[msg.sender] != true, "you are already in a room");
        if(amount > chips[msg.sender]){
            Ichip(token).lock(msg.sender, amount - chips[msg.sender]);
        }
        console.log("three");
        //更新房间玩家信息，加入玩家
        if(Strings.equal(kind, "odd or even")){
            (bool newPlayer, ) = checkPlayer(index, msg.sender);
            require(!newPlayer, "you are already in, changes are allowed now.");
            players[index].push(Player(msg.sender, amount, choice));
        }
        console.log("four");
        chips[msg.sender] += amount;//更新用户总下注额
        isInRoom[msg.sender] = true;
        //是否已满足开奖条件
        if(roomClosed(index)){
            roomSettlement(index);
        }
    }

    //用户离开房间，已下注的筹码不能拿回
    function quit(uint256 index) external{
        (bool existed, uint256 pindex) = checkPlayer(index, msg.sender);
        require(existed, "incorrect player");//玩家需要在房间
        chips[msg.sender] -= players[index][pindex].bet;//用户总下注的筹码不能拿回
        players[index][pindex] = players[index][players[index].length - 1];//删除房间玩家
        players[index].pop();//删除index房间pindex玩家
        isInRoom[msg.sender] = false;
        if(roomClosed(index)){
            roomSettlement(index);
        }
    }

    //离开游戏厅时取回chip，chip包含两部分，投入的部分，游戏过程中赢或者输的数量
    function leave(uint256 amount) external{
        require(amount <= chips[msg.sender], "you don't have so many chips");
        require(isInRoom[msg.sender] != true, "you are still in a room");
        if(chips[msg.sender] != 0){
            uint256 fund = chips[msg.sender];
            chips[msg.sender] -= amount;//更新用户筹码数量
            Ichip(token).retrieve(msg.sender, amount, fund);
        }
    }

    //单局结算
    function roomSettlement(uint256 index) internal{
    //------------------------------------结果-------------------------------------------//
        uint256[] memory numbers = _getRandomNumber(index);//获取随机数
        uint256 sum;
        for(uint256 i=0; i<numbers.length; i++){
            sum += numbers[i];
        }
        rooms[index].result = sum;//更新房间开奖结果
        rooms[index].endTime = block.timestamp;
        console.log("sum: ", sum);
    //-------------------------------------结算-----------------------------------------//
        bool res;
        Player[] memory _players = players[index];//下面的计算使用这个memory变量，节省gas
        if(sum % 2 == 0) res = false;
        else res = true;
        for(uint8 i=0; i < _players.length; i++){
            if(_players[i].odd == res){
                chips[_players[i].id] += _players[i].bet;
            }
            else{
                chips[_players[i].id] -= _players[i].bet;
            }
            isInRoom[_players[i].id] = false;
        }
        emit roomIsClosed(index);//释放事件，外部监控事件被释放，就自动调用dissmissRoom方法
    }

    //解散房间
    function dissmissRoom(uint256 index) external{
        require(msg.sender == admin, "you have no permission to proceed this operation");
        require(block.timestamp > rooms[index].endTime + 100 && rooms[index].endTime != 0, 
            "can't dissmiss now, wait 100seconds after room closed");
        rooms[index] = rooms[rooms.length - 1];
        rooms.pop();//删除房间
        players[index] = players[players.length - 1];
        players.pop();//清理房间用户
        console.log("room is dissmissed, has ", rooms.length, " rooms now");
    }

    //判断房间是否已存在
    function checkRoom(string memory roomName) public view returns(bool, uint256){
        Room[] memory _rooms = rooms;
        for(uint256 i = 0; i < _rooms.length; i++){
            if(Strings.equal(_rooms[i].name, roomName)){
                return (false, i);
            }
        }
        return (true, uint256(rooms.length));
    }

    //用户是否已经在指定房间
    function checkPlayer(uint256 index, address player) public view returns(bool, uint256){
        Player[] memory _players = players[index];
        for(uint8 i = 0; i<_players.length; i++){
            if((_players[i].id == player)){
                return (true, i);
            }
        }
        return (false, _players.length);
    }

    //判断房间是否满足房间关闭的条件
    function roomClosed(uint256 index) internal view returns(bool){
        if(players[index].length >= maxPlayers || players[index].length == 0) return true;//房间人数达上限或所有人已经退出
        return false;
    }

    function getRandomNumber(uint256 index) public view returns(uint256[] memory){
        uint256[] memory randomNumbers = new uint256[](index);
        for(uint256 i=0; i<index; i++){
            uint random = uint(keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp, i))) % 10;
            randomNumbers[i] = random;
        }
        return randomNumbers;
    }
    function _getRandomNumber(uint256 index) internal view returns(uint256[] memory){
        uint256[] memory randomNumbers = new uint256[](players[index].length);
        for(uint256 i=0; i<players[index].length; i++){
            uint random = uint(keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp, i))) % 10;
            randomNumbers[i] = random;
        }
        return randomNumbers;
    }

    function getChipsAmount() external view returns(uint256){
        return chips[msg.sender];
    }
}