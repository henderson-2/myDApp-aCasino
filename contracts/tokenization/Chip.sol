// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "hardhat/console.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Chip is ERC20Permit{

    mapping(address => uint256) internal locked;
    constructor(string memory _name, string memory _symbol) ERC20Permit(_name) ERC20(_name, _symbol){
        // _mint(0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2, 456789);
        // _mint(0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db, 456789);
        // _mint(0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB, 456789);
    }

    //将eth兑换成筹码
    function deposit(address to, uint256 amount) external payable{
        require(msg.value >= amount, "insifficent eth");
        _mint(to, amount);
    }

    //将筹码兑换成eth
    function redeem(address to, uint256 amount) external payable{
        require(amount <= balanceOf(to) - locked[to], "you don't have so many tokens");
        _burn(to, amount);
        (bool success, ) = payable(to).call{value: amount}("");
        require(success, "fail to send eth");
    }

    //从场内取回筹码
    function retrieve(address account, uint256 amount, uint256 fund) external{
        require(amount <= fund, "you don't have so many fund");
        if(fund > locked[account]){//如果现时场内筹码比入场时带入的多，即用户此时赢了筹码
            if(amount > fund - locked[account]){//如果取回的筹码多于赢得的筹码
                transfer(account, fund - locked[account]);//先将赢的筹码从场内转移给用户
                //locked[account] -= amount - (fund - locked[account]);
                locked[account] = fund - amount;//再解锁筹码，就是将带入场的筹码转回给用户
            }
            else{
                transfer(account, amount);
            }
        }
        else{//如果此时是输的
            transferFrom(account, msg.sender, locked[account] - fund);//从用户转走输了的筹码
            locked[account] = fund - amount;//再解锁筹码，就是将带入场的筹码转回给用户
        }
    }

    //带筹码入场，锁定的筹码还属于用户，但不能做任何操作
    function lock(address account, uint256 amount) external{
        console.log(account, " lock ", locked[account]);
        require(amount <= balanceOf(account) - locked[account], "you don't have so many tokens");
        locked[account] += amount;
    }

    //查看锁定的筹码有多少，即用户带了多少筹码入场
    function lockedOf(address account) public view returns(uint256){
        return locked[account];
    }
    
}