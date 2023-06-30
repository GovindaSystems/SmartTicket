// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract MyNFT is ERC721URIStorage {
    uint256 private _tokenIdCounter;

    constructor() ERC721("MyNFT", "MNFT") {}

    function mint(address to) public {
        _mint(to, _tokenIdCounter);
        _tokenIdCounter++;
    }

    function burn(uint256 tokenId) external {
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "caller is not owner nor approved"
        );
        _burn(tokenId);
    }
}
