// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
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
        require(msg.sender == admin, "only admin");
        events.push(Event(name, location, date, ticketPrice, totalTickets));
    }

    function mint(address to, uint256 eventId) public {
        require(msg.sender == admin, "only admin");
        require(eventId < events.length, "event does not exist");

        _mint(to, nextTokenId);
        _setTokenURI(nextTokenId, "tokenURI");
        nextTokenId++;
    }

    function burn(uint256 tokenId) external {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "caller is not owner nor approved");
        _burn(tokenId);
    }
}
