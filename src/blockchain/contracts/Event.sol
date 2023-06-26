// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract Event is AccessControl {
    bytes32 public constant ORGANIZER_ROLE = keccak256("ORGANIZER_ROLE");

    struct Model {
        string name;
        string location;
        uint256 date;
        string description;
        address organizer;
    }

    Model[] public events;

    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(ORGANIZER_ROLE, msg.sender);
    }

    function createEvent(string memory name, string memory location, uint256 date, string memory description) public onlyRole(ORGANIZER_ROLE) {
        events.push(Model({
            name: name,
            location: location,
            date: date,
            description: description,
            organizer: msg.sender
        }));
    }

    function getEvent(uint256 eventId) public view returns (string memory, string memory, uint256, string memory, address) {
        Model memory eventItem = events[eventId];
        return (eventItem.name, eventItem.location, eventItem.date, eventItem.description, eventItem.organizer);
    }
}
