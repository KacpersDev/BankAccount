// SPDX-License-Identifier: MIT

pragma solidity >= 0.7.0 <= 0.9.0;

contract Account {

    address owner;

    mapping(address => uint) map;

    constructor() {
        owner = msg.sender;
    }

    function deposit() external payable  {
        map[msg.sender] += msg.value;
    }

    function withdraw(uint amount) external payable {
        require(amount <= map[msg.sender], "Your account doesnt contains that amount of balance");
        if (amount == map[msg.sender]) {
            map[msg.sender] = 0;
        } else { 
            map[msg.sender] -= amount;
        }

        (bool sent,) = payable(msg.sender).call{value: amount}("");
        require(sent, "Failed to withdraw. Refunding gas.");
    }

    function pay(address add, uint amount) external payable {
        require(map[msg.sender] >= amount, "Not enough balance");
        if (amount == map[msg.sender]) {
            map[msg.sender] = 0;
        } else {
            map[msg.sender] -= amount;
        }
        
        (bool sent,) = payable(add).call{value: amount}("");
        require(sent, "Failed to pay. Refunding gas.");
    }

    function getBalance() public view returns (uint) {
        return map[msg.sender];
    }

    function getAddressBalance(address add) public view returns (uint) {
        return map[add];
    }

    function getBankBalance() public view returns (uint) {
        return address(this).balance;
    }

    receive() external payable {
        map[msg.sender] += msg.value;
    }

    fallback() external payable {
        map[msg.sender] += msg.value;
    }
}
