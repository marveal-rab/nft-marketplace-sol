// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NftMarketplace is ERC721, ERC721URIStorage, Ownable {
    struct MarketItem {
        uint256 tokenId;
        address payable seller;
        address payable owner;
        uint256 price;
        bool sold;
    }

    uint256 private _tokenId;
    uint256 private _itemsSold;
    mapping(uint256 => MarketItem) private _marketItems;
    uint256 listingPrice = 0.0025 ether;

    event MarketItemCreated(
        uint256 indexed tokenId,
        address indexed seller,
        address indexed owner,
        uint256 price
    );

    constructor() ERC721("TWIN CAPES TOKEN", "TCC") Ownable(msg.sender) {}

    // update the price of the NFT
    function updateListingPrice(uint256 _listingPrice) public onlyOwner {
        listingPrice = _listingPrice;
    }

    function getListingPrice() public view returns (uint256) {
        return listingPrice;
    }

    function createToken(
        string memory _tokenURI,
        uint256 _price
    ) public payable returns (uint256) {
        require(
            msg.value == listingPrice,
            "Price must be equal to listing price"
        );
        _safeMint(msg.sender, _tokenId);
        _setTokenURI(_tokenId, _tokenURI);

        createMarketItem(_tokenId, _price);
        _tokenId += 1;
        return _tokenId;
    }

    function createMarketItem(uint256 tokenId, uint256 price) public payable {
        require(price > 0, "Price must be at least 1 wei");
        require(
            msg.value == listingPrice,
            "Price must be equal to listing price"
        );

        address seller = msg.sender;
        address recipient = address(this);
        _marketItems[tokenId] = MarketItem(
            tokenId,
            payable(seller),
            payable(recipient),
            price,
            false
        );

        _transfer(seller, recipient, tokenId);

        emit MarketItemCreated(tokenId, seller, recipient, price);
    }

    function reSellToken(uint256 tokenId, uint256 price) public payable {
        require(
            _marketItems[tokenId].owner == msg.sender,
            "You are not the owner of this token"
        );
        require(
            msg.value == listingPrice,
            "Price must be equal to listing price"
        );

        _marketItems[tokenId].price = price;
        _marketItems[tokenId].sold = false;
        _marketItems[tokenId].seller = payable(msg.sender);
        _marketItems[tokenId].owner = payable(address(this));

        _itemsSold -= 1;

        _transfer(msg.sender, address(this), tokenId);
    }

    function createMarketSale(uint256 tokenId) public payable {
        MarketItem memory item = _marketItems[tokenId];
        require(item.price > 0, "This item is not for sale");
        require(
            msg.value == item.price,
            "Price must be equal to listing price"
        );
        require(item.sold == false, "This item is already sold");

        _marketItems[tokenId].sold = true;
        _marketItems[tokenId].owner = payable(msg.sender);
        _marketItems[tokenId].seller = payable(address(this));

        _itemsSold += 1;

        _transfer(address(this), msg.sender, tokenId);

        payable(address(this)).transfer(listingPrice);
        item.seller.transfer(msg.value);
    }

    function getMarketItem(
        uint256 tokenId
    ) public view returns (MarketItem memory) {
        return _marketItems[tokenId];
    }

    function listMarketItem() public view returns (MarketItem[] memory) {
        uint256 unsoldItemCount = _tokenId - _itemsSold;
        MarketItem[] memory items = new MarketItem[](unsoldItemCount);
        uint256 currIdx = 0;
        for (uint256 i = 0; i < _tokenId; i++) {
            if (_marketItems[i].owner == address(this)) {
                items[currIdx] = _marketItems[i];
                currIdx += 1;
            }
        }
        return items;
    }

    function listMyItems() public view returns (MarketItem[] memory) {
        uint256 itemCount = 0;
        for (uint256 i = 0; i < _tokenId; i++) {
            if (_marketItems[i].seller == msg.sender) {
                itemCount += 1;
            }
        }

        MarketItem[] memory items = new MarketItem[](itemCount);
        uint256 currIdx = 0;
        for (uint256 i = 0; i < _tokenId; i++) {
            if (_marketItems[i].seller == msg.sender) {
                items[currIdx] = _marketItems[i];
                currIdx += 1;
            }
        }
        return items;
    }

    function listMyPurchasedItems() public view returns (MarketItem[] memory) {
        uint256 itemCount = 0;
        for (uint256 i = 0; i < _tokenId; i++) {
            if (_marketItems[i].owner == msg.sender) {
                itemCount += 1;
            }
        }

        MarketItem[] memory items = new MarketItem[](itemCount);
        uint256 currIdx = 0;
        for (uint256 i = 0; i < _tokenId; i++) {
            if (_marketItems[i].owner == msg.sender) {
                items[currIdx] = _marketItems[i];
                currIdx += 1;
            }
        }
        return items;
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
