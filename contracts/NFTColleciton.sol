// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTCollecitonToken is ERC721, ERC721URIStorage, Ownable {
    uint256 private _nextTokenId;

    struct Collection {
        string name;
        string symbol;
        address owner;
    }
    mapping(uint256 => Collection) public collections;

    constructor(
        address initialOwner
    ) ERC721("NFT Colleciton Token", "NCT") Ownable(initialOwner) {}

    event CollectionCreated(
        uint256 tokenId,
        string name,
        string symbol,
        address indexed owner,
        string uri
    );

    function safeMint(
        address to,
        string memory uri,
        string memory name,
        string memory symbol
    ) public {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
        collections[tokenId] = Collection(name, symbol, to);

        emit CollectionCreated(tokenId, name, symbol, to, uri);
    }

    // The following functions are overrides required by Solidity.

    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
