// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTCollection is ERC1155, Ownable {
    uint256 private _nextTokenId;

    string public name;
    string public symbol;
    string public baseUri;

    constructor(
        address initialOwner,
        string memory uri,
        string memory _name,
        string memory _symbol
    ) ERC1155(uri + "{id}.json") Ownable(initialOwner) {
        baseUri = uri;
        name = _name;
        symbol = _symbol;
    }

    function mint(
        address account,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public onlyOwner {
        uint tokenId = _nextTokenId++;
        _mint(account, tokenId, amount, data);
    }

    function mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public onlyOwner {
        _mintBatch(to, ids, amounts, data);
    }

    function uri(
        uint256 _tokenId
    ) public view override returns (string memory) {
        return
            string(
                abi.encodePacked(baseUri, Strings.toString(_tokenId), ".json")
            );
    }
}
