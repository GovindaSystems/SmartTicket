// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "./Ticket.sol";

contract Wallet is IERC721Receiver {
    function onERC721Received(address, address, uint256, bytes calldata) external pure override returns(bytes4) {
        return this.onERC721Received.selector;
    }

    function burn(Ticket token, uint256 tokenId) public {
        token.burn(tokenId);
    }
}
