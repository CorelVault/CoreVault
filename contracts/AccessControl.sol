// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IAccessControl.sol";

contract AccessControl is IAccessControl {
    mapping(bytes32 => mapping(address => bool)) private _roles;
    
    modifier onlyRole(bytes32 role) {
        require(_roles[role][msg.sender], "AccessControl: not authorized");
        _;
    }

    function hasRole(bytes32 role, address account) external view override returns (bool) {
        return _roles[role][account];
    }

    function grantRole(bytes32 role, address account) external override onlyRole(role) {
        _roles[role][account] = true;
        emit RoleGranted(role, account, msg.sender);
    }

    function revokeRole(bytes32 role, address account) external override onlyRole(role) {
        _roles[role][account] = false;
        emit RoleRevoked(role, account, msg.sender);
    }
}
