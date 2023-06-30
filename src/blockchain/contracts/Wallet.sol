// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./Ticket.sol";

contract Wallet is IERC721Receiver {

    address public admin;

    constructor() {
        admin = msg.sender;
    }

    function getAdmin() public view returns(address) {
        return admin;
    }

    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external override returns(bytes4) {
        
        IERC721(msg.sender).approve(operator, tokenId);
        return this.onERC721Received.selector;
    }
}
