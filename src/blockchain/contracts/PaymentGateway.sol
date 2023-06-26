// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract PaymentGateway is AccessControl {
    bytes32 public constant ORGANIZER_ROLE = keccak256("ORGANIZER_ROLE");

    enum PaymentMethod { CreditCard, Boleto, Pix }

    struct EventPaymentMethods {
        bool creditCard;
        bool boleto;
        bool pix;
    }

    mapping(uint256 => EventPaymentMethods) public eventPaymentMethods;

    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(ORGANIZER_ROLE, msg.sender);
    }

    function setPaymentMethods(uint256 eventId, bool creditCard, bool boleto, bool pix) public onlyRole(ORGANIZER_ROLE) {
        eventPaymentMethods[eventId] = EventPaymentMethods({
            creditCard: creditCard,
            boleto: boleto,
            pix: pix
        });
    }
}
