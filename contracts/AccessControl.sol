// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract AccessControl is Ownable {
    mapping(address => bool) private operators;
    mapping(address => bool) private admins;

    event AdminAdded(address indexed admin);
    event AdminRemoved(address indexed admin);
    event OperatorAdded(address indexed operator);
    event OperatorRemoved(address indexed operator);

    modifier onlyAdmin() {
        require(admins[msg.sender] || msg.sender == owner(), "Not an admin");
        _;
    }

    modifier onlyOperator() {
        require(operators[msg.sender], "Not an operator");
        _;
    }

    constructor() {
        admins[msg.sender] = true;
        emit AdminAdded(msg.sender);
    }

    function addAdmin(address _admin) external onlyOwner {
        require(_admin != address(0), "Invalid address");
        require(!admins[_admin], "Already an admin");
        admins[_admin] = true;
        emit AdminAdded(_admin);
    }

    function removeAdmin(address _admin) external onlyOwner {
        require(admins[_admin], "Not an admin");
        admins[_admin] = false;
        emit AdminRemoved(_admin);
    }

    function addOperator(address _operator) external onlyAdmin {
        require(_operator != address(0), "Invalid address");
        require(!operators[_operator], "Already an operator");
        operators[_operator] = true;
        emit OperatorAdded(_operator);
    }

    function addOperators(address[] calldata _operators) external onlyAdmin {
        for (uint256 i = 0; i < _operators.length; i++) {
            address _operator = _operators[i];
            if (_operator != address(0) && !operators[_operator]) {
                operators[_operator] = true;
                emit OperatorAdded(_operator);
            }
        }
    }

    function removeOperator(address _operator) external onlyAdmin {
        require(operators[_operator], "Not an operator");
        operators[_operator] = false;
        emit OperatorRemoved(_operator);
    }

    function removeOperators(address[] calldata _operators) external onlyAdmin {
        for (uint256 i = 0; i < _operators.length; i++) {
            address _operator = _operators[i];
            if (operators[_operator]) {
                operators[_operator] = false;
                emit OperatorRemoved(_operator);
            }
        }
    }

    function isAdmin(address _admin) external view returns (bool) {
        return admins[_admin];
    }

    function isOperator(address _operator) external view returns (bool) {
        return operators[_operator];
    }
}
