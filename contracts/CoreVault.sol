// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleERC20 {
    string public name = "SimpleToken";
    string public symbol = "SIM";
    uint8 public decimals = 18;
    uint256 public totalSupply = 1000000 * (10 ** uint256(decimals));
    address public owner;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    uint256 public maxTxAmount = totalSupply / 100;
    uint256 public feePercent = 2;
    address public feeReceiver;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
        feeReceiver = msg.sender;
        balanceOf[msg.sender] = totalSupply;
    }

    function transfer(address recipient, uint256 amount) public returns (bool) {
        require(amount <= maxTxAmount, "Exceeds max tx limit");
        uint256 fee = (amount * feePercent) / 100;
        uint256 amountAfterFee = amount - fee;
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amountAfterFee;
        balanceOf[feeReceiver] += fee;
        emit Transfer(msg.sender, recipient, amountAfterFee);
        emit Transfer(msg.sender, feeReceiver, fee);
        return true;
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        require(amount <= allowance[sender][msg.sender], "Allowance exceeded");
        require(amount <= maxTxAmount, "Exceeds max tx limit");
        uint256 fee = (amount * feePercent) / 100;
        uint256 amountAfterFee = amount - fee;
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amountAfterFee;
        balanceOf[feeReceiver] += fee;
        emit Transfer(sender, recipient, amountAfterFee);
        emit Transfer(sender, feeReceiver, fee);
        return true;
    }

    function setMaxTxAmount(uint256 newMax) external onlyOwner {
        maxTxAmount = newMax;
    }

    function setFeePercent(uint256 newFee) external onlyOwner {
        require(newFee <= 10, "Fee too high");
        feePercent = newFee;
    }
}
