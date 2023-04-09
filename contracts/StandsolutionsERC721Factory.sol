// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Create2.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./StandsolutionsERC721.sol";

contract StandsolutionsERC721Factory is Ownable {
    address public signer;

    event StandsolutionsERC721Created(address indexed sender, address nft);

    constructor (address _signer) {
        signer = _signer;
    }

    function createStandsolutionsERC721(string calldata name, string calldata symbol, string calldata baseURI, bool transferable) external {
        bytes memory bytecode = abi.encodePacked(type(StandsolutionsERC721).creationCode, abi.encode(name, symbol, transferable));
        bytes32 salt = keccak256(abi.encodePacked(msg.sender, block.number, name, symbol, transferable));
        address nft = Create2.deploy(0, salt, bytecode);
        StandsolutionsERC721(nft).setBaseURI(string(abi.encodePacked(baseURI)));
        StandsolutionsERC721(nft).setSigner(signer);
        StandsolutionsERC721(nft).transferOwnership(signer);
        emit StandsolutionsERC721Created(msg.sender, nft);
    }

    function setSigner(address account) external onlyOwner {
        signer = account;
    }
}