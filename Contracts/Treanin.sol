// SPDX-License-Identifier: MIT
pragma solidity =0.8.20;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

import "./library/Helper.sol";

contract Treanin is
    Initializable,
    ERC721Upgradeable,
    OwnableUpgradeable,
    AccessControlUpgradeable,
    UUPSUpgradeable
{
    mapping(uint => Helper.TreaninProps) public treaninProps; 
    uint private _nextTokenId;
    event MintNFTWithFaction(
        address _to,
        uint _tokenId
    );

    constructor() {
        _disableInitializers();
    }

    function initialize(
        address initialOwner
    ) public initializer {

        __Ownable_init(initialOwner);
        __ERC721_init("Treanin", "Treanin");
        __AccessControl_init();
        __UUPSUpgradeable_init();

    }

    function forge(
        address to,
        uint _quantity
    ) public {
        require(
            (_quantity > 0) , "Invalid Quantity or Faction");
        for (uint i = 0; i < _quantity; i++) {
            uint tokenId = _nextTokenId++;
            _safeMint(to, tokenId);
            Helper.TreaninProps storage props = treaninProps[tokenId];
            props.summoned = false;
            props.mintTime = block.timestamp;
            emit MintNFTWithFaction(to, tokenId);
        }
    }

    function activate(
        uint _nftId, 
        uint _rarity, // 1 - 6
        uint _id // 0 - 19
    ) public onlyOwner {
        Helper.TreaninProps storage props = treaninProps[_nftId];
        require(!props.summoned, "NFT already activated"); // can only activate once
        props.summoned = true;
        props.rarity = _rarity;
        props.ID = _id;
    }

    function _update( // Internal marketplace update
        address to,
        uint tokenId,
        address auth
    )
        internal
        override(ERC721Upgradeable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        override(ERC721Upgradeable, AccessControlUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}

}
