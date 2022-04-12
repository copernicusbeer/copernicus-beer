// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";


contract CopernicusBeer is ERC2981, ERC721, ERC721Enumerable, ERC721URIStorage, Ownable  {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;

    // Optional mapping for uris of the 24 qrcode's
    mapping(uint256 => string) private _qrcodeURIs;

    constructor() ERC721("Copernicus Beer", "CPBEER") {
        //set deployer as the initial owner
        //_setDefaultRoyalty(_msgSender(), 1000);
    }

    function createBeerNFT(string memory uri) public onlyOwner returns (uint256) {
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();
        _safeMint( _msgSender() , newTokenId);
        _setTokenURI(newTokenId, uri);
        return newTokenId;
    }


    function qrcodeURI(uint256 tokenId) public view returns (string memory) {
        require(_exists(tokenId), "CopernicusBeer: URI query for nonexistent token");
        return _qrcodeURIs[tokenId];
    }

    function setQrcodeURI(uint256 tokenId, string memory _qrcodeURI) public {
        require(_exists(tokenId), "CopernicusBeer: URI set of nonexistent token");
        require(_isApprovedOrOwner(_msgSender(), tokenId), "CopernicusBeer: caller is not owner nor approved");
        _qrcodeURIs[tokenId] = _qrcodeURI;
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
        _resetTokenRoyalty(tokenId);
        if (bytes(_qrcodeURIs[tokenId]).length != 0) {
            delete _qrcodeURIs[tokenId];
        }
    }

    function _transferOwnership(address newOwner) internal override(Ownable) {
        super._transferOwnership(newOwner);
        if (newOwner== address(0)) {
            _deleteDefaultRoyalty();
        } else {
            _setDefaultRoyalty(newOwner, 1000);
        }
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

     function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable, ERC2981)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

}
