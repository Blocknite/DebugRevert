// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "./interface/IERC721.sol";
import "./library/Helper.sol";

contract NFTMinter is Initializable, OwnableUpgradeable, UUPSUpgradeable {

    address nftAddress;

    constructor() {
        _disableInitializers();
    }

    // Initialize all variables after contract deployment
    function initialize(
        address initialOwner,
        address _nftAddress
    ) public initializer {
        require(initialOwner != address(0), "Invalid Owner");
        require(_nftAddress != address(0), "Invalid NFT Address");
        nftAddress = _nftAddress;
        OwnableUpgradeable.__Ownable_init(initialOwner);
        __UUPSUpgradeable_init();


    }

    function whyBroken(uint _nftId) external view returns (Helper.TreaninProps memory) {
        Helper.TreaninProps memory props = IERC721(nftAddress).treaninProps(_nftId);
        require(props.summoned, "You have not activated your NFT");
        return(props);
    }

    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}

}