// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./AccessManager.sol";
import "./Wallet.sol";

contract User is AccessManager {
    struct Model {
        string name;
        string email;
        string phone;
        address wallet;
        bool registered;
        bool isOrganizer;
        string document;
    }

    mapping(string => Model) public users;

    constructor() {
        _setupRole(ADMIN_ROLE, msg.sender);
    }

    function register(
        string memory name,
        string memory email,
        string memory phone
    ) public {
        require(bytes(name).length > 0, "Name is required");
        require(bytes(email).length > 0, "E-mail is required");
        require(bytes(phone).length > 0, "Phone is required");
        require(users[email].registered == false, "E-mail already exists");

        users[email] = Model({
            name: name,
            email: email,
            phone: phone,
            wallet: address(new Wallet()),
            registered: true,
            isOrganizer: false,
            document: ""
        });

        grantRole(USER_ROLE, users[email].wallet);
    }

    function getInfo(
        string memory email
    )
        public
        view
        onlyRoles(USER_ROLE, ADMIN_ROLE)
        returns (string memory name, address wallet)
    {
        Model memory user = users[email];
        return (user.name, user.wallet);
    }

    function setOrganizer(
        string memory email,
        string memory document
    ) public onlyRole(ADMIN_ROLE) {
        require(bytes(document).length == 0, "Document is required");

        users[email].document = document;
        users[email].isOrganizer = true;

        grantRole(ORGANIZER_ROLE, msg.sender);
    }
}
