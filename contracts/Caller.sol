// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import {Proxy} from "./Proxy.sol";

contract Caller{
    address payable public proxy;

    constructor(address payable _proxy){
        proxy = _proxy;
    }

    function setName(string memory newName) external{
        (bool success, ) = proxy.call(abi.encodeWithSignature("setName(string)", newName));
        require(success);
    }

    function getName() external view returns(string memory){
        return Proxy(proxy).name();
    }

    function update(address newImpl) external{
        (bool success, ) = proxy.call(abi.encodeWithSignature("updateImpl(address)", newImpl));
        require(success);
    }

    function getImpl() external view returns(address){
        return Proxy(proxy).impl();
    }
}