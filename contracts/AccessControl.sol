// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IAccessControl.sol";

contract AccessControl is IAccessControl {
    mapping(bytes32 => mapping(address => bool)) private _roles;
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

    modifier onlyRole(bytes32 role) {
        require(_roles[role][msg.sender], "AccessControl: Unauthorized");
        _;
    }

    constructor() {
        _roles[ADMIN_ROLE][msg.sender] = true;
    }

    function hasRole(bytes32 role, address account) external view override returns (bool) {
        return _roles[role][account];
    }

    function grantRole(bytes32 role, address account) external override onlyRole(ADMIN_ROLE) {
        _roles[role][account] = true;
        emit RoleGranted(role, account, msg.sender);
    }

    function revokeRole(bytes32 role, address account) external override onlyRole(ADMIN_ROLE) {
        _roles[role][account] = false;
        emit RoleRevoked(role, account, msg.sender);
    }
}
