// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./AccessManager.sol";

contract PaymentGateway is AccessManager {
    enum PaymentMethod {
        CreditCard,
        Boleto,
        Pix
    }

    struct EventPaymentMethods {
        bool creditCard;
        bool boleto;
        bool pix;
    }

    mapping(uint256 => EventPaymentMethods) public eventPaymentMethods;

    constructor() {
        _setupRole(ADMIN_ROLE, msg.sender);
    }

    function setPaymentMethods(
        uint256 eventId,
        bool creditCard,
        bool boleto,
        bool pix
    ) public {
        eventPaymentMethods[eventId] = EventPaymentMethods({
            creditCard: creditCard,
            boleto: boleto,
            pix: pix
        });
    }
}
