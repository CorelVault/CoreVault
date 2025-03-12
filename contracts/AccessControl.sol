// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * Abstract contract for managing owner and admin roles.
 */
abstract contract AccessControl {
    address public owner;
    mapping(address => bool) private admins;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event AdminAdded(address indexed admin);
    event AdminRemoved(address indexed admin);

    /**
     * @dev Restricts function access to the contract owner.
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    /**
     * @dev Restricts function access to admins or the owner.
     */
    modifier onlyAdmin() {
        require(admins[msg.sender] || msg.sender == owner, "Not admin");
        _;
    }

    /**
     * @dev Sets the contract deployer as the initial owner.
     */
    constructor() {
        owner = msg.sender;
        emit OwnershipTransferred(address(0), msg.sender);
    }

    /**
     * @dev Transfers ownership to a new address.
     * @param newOwner Address of the new owner.
     */
    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Invalid address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    /**
     * @dev Adds a new admin.
     * @param admin Address to be granted admin rights.
     */
    function addAdmin(address admin) external onlyOwner {
        require(admin != address(0), "Invalid address");
        require(!admins[admin], "Already an admin");
        admins[admin] = true;
        emit AdminAdded(admin);
    }

    /**
     * @dev Removes an admin.
     * @param admin Address to be revoked admin rights.
     */
    function removeAdmin(address admin) external onlyOwner {
        require(admins[admin], "Not an admin");
        admins[admin] = false;
        emit AdminRemoved(admin);
    }

    /**
     * @dev Checks if an address is an admin.
     * @param account Address to check.
     * @return bool True if the address is an admin, otherwise false.
     */
    function isAdmin(address account) external view returns (bool) {
        return admins[account];
    }
}
