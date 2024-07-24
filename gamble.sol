// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

struct Player {
    address addr;
    uint256 amount;
}

contract gameble {
    Player[] bigs;
    Player[] smalls;
    uint256 totalBigAmount;
    uint256 totalSmallAmount;
    bool isFinish;
    address owner;
    uint256 min;
    uint256 endTime;

    constructor(uint256 _min) {
        owner = msg.sender;
        min = _min;
        endTime = block.timestamp + 120;
    }

    modifier canDo() {
        require(!isFinish, "game finish");
        require(block.timestamp < endTime, "time out");
        _;
    }

    function bet(bool isBig) public payable canDo {
        require(msg.value > min);
        if (isBig) {
            bigs.push(Player(msg.sender, msg.value));
            totalBigAmount += msg.value;
        } else {
            smalls.push(Player(msg.sender, msg.value));
            totalSmallAmount += msg.value;
        }
    }

    function open() public payable canDo {
        isFinish = true;
        uint256 random = uint256(
            keccak256(abi.encode(block.timestamp, msg.sender, isFinish))
        ) % 18;
        if (random > 8) {
            for (uint256 i = 0; i < bigs.length; i++) {
                uint256 bonus = (((totalSmallAmount * bigs[i].amount) /
                    totalBigAmount) * 90) / 100;
                payable(bigs[i].addr).transfer(bonus);
            }
            payable(owner).transfer((totalSmallAmount * 10) / 100);
        } else {
            for (uint256 i = 0; i < smalls.length; i++) {
                uint256 bonus = (((totalBigAmount * smalls[i].amount) /
                    totalSmallAmount) * 90) / 100;
                payable(smalls[i].addr).transfer(bonus);
            }
            payable(owner).transfer((totalBigAmount * 10) / 100);
        }
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
