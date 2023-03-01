// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract TokenSwap {
    IERC20 public token1;
    IERC20 public token2;
    address public owner;
    uint256 public rate; // rate of token1 to token2
    uint256 public fee; // fee in percentage

    event Swap(address indexed from, uint256 token1Amount, uint256 token2Amount);

    constructor(IERC20 _token1, IERC20 _token2, uint256 _rate, uint256 _fee) {
        token1 = _token1;
        token2 = _token2;
        rate = _rate;
        fee = _fee;
        owner = msg.sender;
    }

    function swap(uint256 _token1Amount) public {
        uint256 token2Amount = (_token1Amount * rate) / 1000;
        uint256 feeAmount = (token2Amount * fee) / 100;
        require(token1.transferFrom(msg.sender, address(this), _token1Amount), "Transfer of token1 failed");
        require(token2.transfer(msg.sender, token2Amount - feeAmount), "Transfer of token2 failed");
        require(token2.transfer(owner, feeAmount), "Transfer of fee failed");
        emit Swap(msg.sender, _token1Amount, token2Amount);
    }
}