// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Create2.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./StandsolutionsERC1155.sol";

contract StandsolutionsERC1155Factory is Ownable {
    address public signer;

    event StandsolutionsERC1155Created(address indexed sender, address nft);

    constructor (address _signer) {
        signer = _signer;
    }

    function createStandsolutionsERC1155(string calldata baseURI, bool transferable) external {
        bytes memory bytecode = abi.encodePacked(type(StandsolutionsERC1155).creationCode, abi.encode(baseURI, transferable));
        bytes32 salt = keccak256(abi.encodePacked(msg.sender, block.number, baseURI, transferable));
        address nft = Create2.deploy(0, salt, bytecode);
        StandsolutionsERC1155(nft).setBaseURI(string(abi.encodePacked(baseURI)));
        StandsolutionsERC1155(nft).setSigner(signer);
        StandsolutionsERC1155(nft).transferOwnership(signer);
        emit StandsolutionsERC1155Created(msg.sender, nft);
    }

    function setSigner(address account) external onlyOwner {
        signer = account;
    }
}