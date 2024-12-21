// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AssignmentRewards {
    address public owner;
    mapping(address => uint256) public rewardBalances;

    event RewardClaimed(address indexed user, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    function addReward(address user, uint256 amount) public onlyOwner {
        rewardBalances[user] += amount;
    }

    function claimReward() public {
        uint256 amount = rewardBalances[msg.sender];
        require(amount > 0, "No rewards available");

        rewardBalances[msg.sender] = 0;
        payable(msg.sender).transfer(amount);

        emit RewardClaimed(msg.sender, amount);
    }

    function withdrawExcess() public onlyOwner {
        uint256 balance = address(this).balance;
        payable(owner).transfer(balance);
    }
}