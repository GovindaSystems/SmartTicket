// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract AccessManager is AccessControl {

    bytes32 public constant ORGANIZER_ROLE = keccak256("ORGANIZER_ROLE");
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant USER_ROLE = keccak256("USER_ROLE");
    
    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(ORGANIZER_ROLE, msg.sender);
    }

    modifier onlyRole(bytes32 role) override {
        require(hasRole(role, msg.sender), "AccessManager: account does not have required role");
        _;
    }

    function grantOrganizerRole(address account) public onlyRole(DEFAULT_ADMIN_ROLE) {
        grantRole(ORGANIZER_ROLE, account);
    }

    function revokeOrganizerRole(address account) public onlyRole(DEFAULT_ADMIN_ROLE) {
        revokeRole(ORGANIZER_ROLE, account);
    }
}
