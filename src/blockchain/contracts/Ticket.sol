// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "./AccessManager.sol"; // Import the AccessManager contract

contract Ticket is ERC721URIStorage {
    uint256 public nextTokenId;
    address public admin;
    AccessManager public accessManager; // Create an instance of AccessManager

    struct Event {
        string name;
        string location;
        uint256 date;
        uint256 ticketPrice;
        uint256 totalTickets;
    }

    Event[] public events;

    constructor(address accessManagerAddress) ERC721("EventTicket", "ETKT") {
        admin = msg.sender;
        accessManager = AccessManager(accessManagerAddress); // Initialize the AccessManager instance
    }

    function createEvent(
        string memory name,
        string memory location,
        uint256 date,
        uint256 ticketPrice,
        uint256 totalTickets
    ) external {
        require(
            accessManager.hasRole(accessManager.ORGANIZER_ROLE(), msg.sender),
            "only organizer"
        ); // Check if the sender has the ORGANIZER_ROLE
        events.push(Event(name, location, date, ticketPrice, totalTickets));
    }

    function mint(address to, uint256 eventId) public {
        require(
            accessManager.hasRole(accessManager.ORGANIZER_ROLE(), msg.sender),
            "only organizer"
        ); // Check if the sender has the ORGANIZER_ROLE
        require(eventId < events.length, "event does not exist");
        _safeMint(to, nextTokenId);
        _setTokenURI(nextTokenId, "tokenURI");
        nextTokenId++;
    }

    function burn(uint256 tokenId) external {
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "caller is not owner nor approved"
        );
        _burn(tokenId);
    }
}
