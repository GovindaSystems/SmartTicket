// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//TODO : Mudar o nome do objeto Ticket

import "./AccessManager.sol";

contract CustomerSupport is AccessManager {
    struct Model {
        address user;
        string message;
        string response;
        bool resolved;
    }

    Model[] public models;

    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(ADMIN_ROLE, msg.sender);
    }

    function submitTicket(string memory message) public {
        models.push(
            Model({
                user: msg.sender,
                message: message,
                response: "",
                resolved: false
            })
        );
    }

    function respondToTicket(
        uint256 ticketId,
        string memory response
    ) public onlyRole(ADMIN_ROLE) {
        Model storage model = models[ticketId];
        require(!model.resolved, "Ticket already resolved");
        model.response = response;
    }

    function resolveTicket(uint256 ticketId) public onlyRole(ADMIN_ROLE) {
        Model storage model = models[ticketId];
        model.resolved = true;
    }
}
