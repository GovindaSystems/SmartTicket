// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract UserRegistry is AccessControl {
    bytes32 public constant USER_ROLE = keccak256("USER_ROLE");

    struct User {
        string name;
        string email;
        bool registered;
    }

    mapping(address => User) public users;

    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function registerUser(string memory name, string memory email) public {
        require(!users[msg.sender].registered, "User already registered");

        users[msg.sender] = User({
            name: name,
            email: email,
            registered: true
        });

        grantRole(USER_ROLE, msg.sender);
    }

    function getUserInfo(address userAddress) public view returns (string memory name, string memory email) {
        User memory user = users[userAddress];
        require(user.registered, "User not registered");
        return (user.name, user.email);
    }
}
