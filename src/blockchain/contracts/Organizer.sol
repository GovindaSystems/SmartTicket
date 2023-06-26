// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract Organizer is AccessControl {
    bytes32 public constant ORGANIZER_ROLE = keccak256("ORGANIZER_ROLE");

    struct Model {
        string name;
        string contactInfo;
        bool registered;
    }

    mapping(address => Model) public organizers;

    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(ORGANIZER_ROLE, msg.sender);
    }

    function registerOrganizer(string memory name, string memory contactInfo) public {
        require(!organizers[msg.sender].registered, "Organizer already registered");
        organizers[msg.sender] = Model({
            name: name,
            contactInfo: contactInfo,
            registered: true
        });
        grantRole(ORGANIZER_ROLE, msg.sender);
    }

    function updateOrganizerInfo(string memory name, string memory contactInfo) public onlyRole(ORGANIZER_ROLE) {
        Model storage organizer = organizers[msg.sender];
        organizer.name = name;
        organizer.contactInfo = contactInfo;
    }
}
