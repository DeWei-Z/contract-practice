// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract auction {
    address public owner;
    address public seller;
    uint256 public maxPrice;
    address public maxBider;
    uint256 public startPrice;
    bool public isFinish;

    event BidEvent(address bider, uint256 price);
    event EndBid(address bider, uint256 finalPrice);

    modifier unfinished() {
        require(!isFinish, "unfinished");
        _;
    }

    constructor(address _seller, uint256 _start) {
        owner = msg.sender;
        seller = _seller;
        startPrice = _start;
        maxPrice = _start;
        isFinish = false;
    }

    function bid(uint256 _amount) public payable unfinished {
        require(_amount > maxPrice, "_amount>maxPrice");
        require(_amount == msg.value, "_amount==msg.value");
        if (maxBider != address(0)) {
            payable(maxBider).transfer(maxPrice);
        }
        maxPrice = _amount;
        maxBider = msg.sender;
        emit BidEvent(msg.sender, _amount);
    }

    function endBid() public payable unfinished {
        require(msg.sender == owner, "msg.sender==owner");
        isFinish = true;
        payable(seller).transfer((maxPrice * 90) / 100);
        payable(owner).transfer((maxPrice * 10) / 100);
        emit EndBid(maxBider, maxPrice);
    }
}
