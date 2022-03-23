// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


contract CopernicusBeer is ERC721, ERC721URIStorage, Ownable  {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;

    constructor() ERC721("Copernicus Beer", "CPBEER") {
        //set deployer as the initial owner
    }

    function createBeerNFT(string memory uri) public onlyOwner returns (uint256) {
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();
        _safeMint( _msgSender() , newTokenId);
        _setTokenURI(newTokenId, uri);
        return newTokenId;
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

}
