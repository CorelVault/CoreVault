// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IAccessControl {
    event AdminAdded(address indexed admin);
    event AdminRemoved(address indexed admin);
    event OperatorAdded(address indexed operator);
    event OperatorRemoved(address indexed operator);

    function addAdmin(address _admin) external;
    function removeAdmin(address _admin) external;
    function addOperator(address _operator) external;
    function addOperators(address[] calldata _operators) external;
    function removeOperator(address _operator) external;
    function removeOperators(address[] calldata _operators) external;
    function isAdmin(address _admin) external view returns (bool);
    function isOperator(address _operator) external view returns (bool);
}
