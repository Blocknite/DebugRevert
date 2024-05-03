pragma solidity =0.8.20;

import "../library/Helper.sol";

interface IERC721 {
    function treaninProps(uint _nftID) external view returns (Helper.TreaninProps memory);
}