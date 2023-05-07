// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "ERC721A/ERC721A.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";

contract ERC721AToken is ERC721A, Ownable {
    constructor() ERC721A("BatchableToken", "BTK") {}

    // Mint function
    function mint(address to, uint256 amount) public onlyOwner {
        _safeMint(to, amount);
    }
}
