// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract AccessManager is AccessControl {
    bytes32 public constant ORGANIZER_ROLE = keccak256("ORGANIZER_ROLE");
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant USER_ROLE = keccak256("USER_ROLE");

    constructor() {
        _setupRole(ADMIN_ROLE, msg.sender);
        _setupRole(ORGANIZER_ROLE, msg.sender);
    }

    modifier onlyRoles(bytes32 role1, bytes32 role2) {
        require(
            hasRole(role1, msg.sender) || hasRole(role2, msg.sender),
            "AccessManager: account does not have required role"
        );
        _;
    }

    function grantOrganizerRole(address account) public onlyRole(ADMIN_ROLE) {
        grantRole(ORGANIZER_ROLE, account);
    }

    function revokeOrganizerRole(address account) public onlyRole(ADMIN_ROLE) {
        revokeRole(ORGANIZER_ROLE, account);
    }
}
