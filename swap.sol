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


/**********
we define a smart contract called TokenSwap that allows users to swap one ERC20 token (token1) for another ERC20 token (token2) at a specified rate. The smart contract also charges a fee for each swap.

The swap function takes one argument _token1Amount which is the amount of token1 that the user wants to swap. The function calculates the equivalent amount of token2 using the rate and deducts the fee before transferring the tokens.

The function first transfers the token1 from the user to the smart contract using the transferFrom function of the token1 contract. It then calculates the amount of token2 to transfer to the user and deducts the fee from it. The remaining amount is transferred to the user using the transfer function of the token2 contract.

The fee amount is also calculated and transferred to the owner of the smart contract using the transfer function of the token2 contract.

Finally, the function emits a Swap event indicating the address of the user, the amount of token1 and token2 swapped.

Note that this is a simple example, and a more complex swap function may be required depending on the requirements of your dApp. It is important to thoroughly test and audit your smart contract before deploying it to a production environment.
**********/
