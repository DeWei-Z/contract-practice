// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract redPacket {
    bool public rType;
    uint8 public rCount;
    uint256 public rAmount;
    address public boss;
    mapping(address => bool) hasRob;

    constructor(bool isAvg, uint8 _count, uint256 _amount) payable {
        rType = isAvg;
        rCount = _count;
        rAmount = _amount;
        boss = msg.sender;
    }

    function getBalance() public view returns (uint256) {
        return (address(this).balance);
    }

    function robPacket() public payable {
        require(rCount > 0, "rCount>0");
        require(rAmount > 0, "rAmount>0");
        require(!hasRob[msg.sender], "!hasRob[msg.sender]");
        hasRob[msg.sender] = true;
        if (rType) {
            uint256 amount = getBalance() / rCount;
            payable(msg.sender).transfer(amount);
        } else {
            if (rCount == 1) {
                payable(msg.sender).transfer(getBalance());
            } else {
                uint256 random = uint256(
                    keccak256(
                        abi.encode(
                            boss,
                            rCount,
                            rAmount,
                            block.timestamp,
                            msg.sender
                        )
                    )
                ) % 10;
                uint256 amount = (getBalance() * random) / 10;
                payable(msg.sender).transfer(amount);
            }
        }
        rCount--;
    }

    function kill() public payable {
        selfdestruct(payable(boss));
    }
}
