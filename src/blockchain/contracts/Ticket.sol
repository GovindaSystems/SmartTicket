// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract Ticket is ERC721URIStorage {
    uint256 public nextTokenId;
    address public admin;

    struct Event {
        string name;
        string location;
        uint256 date;
        uint256 ticketPrice;
        uint256 totalTickets;
    }

    Event[] public events;

    constructor() ERC721("EventTicket", "ETKT") {
        admin = msg.sender;
    }

    function createEvent(
        string memory name,
        string memory location,
        uint256 date,
        uint256 ticketPrice,
        uint256 totalTickets
    ) external {
        require(admin == msg.sender, "only admin");
        events.push(Event(name, location, date, ticketPrice, totalTickets));
    }

    function mint(address to, uint256 eventId) public {
        require(admin == msg.sender, "only admin");
        require(eventId < events.length, "event does not exist");

        _safeMint(to, nextTokenId);
        _setTokenURI(nextTokenId, "tokenURI");

        nextTokenId++;
    }

    function burn(address from, uint256 tokenId) external {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "caller is not owner nor approved");

        safeTransferFrom(from, admin, tokenId);
        _burn(tokenId);
    }
}
