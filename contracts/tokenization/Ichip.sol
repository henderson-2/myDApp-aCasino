// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

interface Ichip {
    function deposit(address to, uint256 amount) external payable;
    function retrieve(address to, uint256 amount, uint256 fund) external payable;
    function lock(address account, uint256 amount) external;
    
}