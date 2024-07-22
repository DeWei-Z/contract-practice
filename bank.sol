// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract bank_demo {
    string public bankName;
    uint256 totalAmount;
    address public admin;
    mapping(address => uint256) balances;
    constructor(string memory _name) {
        bankName = _name;
        admin = msg.sender;
    }

    function getBalance() public view returns (uint256, uint256) {
        return (address(this).balance, totalAmount);
    }

    function deposit(uint256 _amount) public payable {
        require(_amount > 0, "(_amount > 0");
        require(msg.value == _amount, "msg.value==_amount");
        balances[msg.sender] += _amount;
        totalAmount += _amount;
        require(address(this).balance == totalAmount, "address(this)");
    }
    function withdraw(uint256 _amount) public payable {
        require(_amount > 0);
        require(balances[msg.sender] >= _amount);
        payable(msg.sender).transfer(_amount);
        balances[msg.sender] -= _amount;
        totalAmount -= _amount;
        require(address(this).balance == totalAmount);
    }
    function transfer(address _to, uint256 _amount) public payable {
        require(_amount > 0);
        require(balances[msg.sender] >= _amount);
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
    }
    function balanceOf(address _who) public view returns (uint256) {
        return balances[_who];
    }
}
