// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract StandsolutionsERC721 is ERC721Enumerable, Ownable, Pausable {
    using Strings for uint256;
    string public baseURI;
    address public signer;
    bool public transferable;

    constructor (string memory name, string memory symbol, bool limit) ERC721(name, symbol) {
        transferable = limit;
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
        super._beforeTokenTransfer(from, to, tokenId);
        require(transferable, "ERC721: non transferable");
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        super._requireMinted(tokenId);
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
    }

    function mint(address to, uint256 tokenId) external onlyOwner {
        super._safeMint(to, tokenId);
    }

    function singleMint(uint256 tokenId, uint256 deadline, bytes memory signature) external whenNotPaused {
        require(block.timestamp <= deadline, "expired");
        bytes32 hash = ECDSA.toEthSignedMessageHash(keccak256(abi.encode(msg.sender, tokenId, deadline)));
        require(ECDSA.recover(hash, signature) == signer, "invalid signer");
        super._safeMint(msg.sender, tokenId);
    }

    function batchMint(uint256[] memory tokenIds, uint256 deadline, bytes memory signature) external whenNotPaused {
        require(block.timestamp <= deadline, "expired");
        bytes32 hash = ECDSA.toEthSignedMessageHash(keccak256(abi.encode(msg.sender, tokenIds, deadline)));
        require(ECDSA.recover(hash, signature) == signer, "invalid signer");
        for (uint256 i = 0; i < tokenIds.length; i++) {
            uint256 id = tokenIds[i];
            super._safeMint(msg.sender, id);
        }
    }

    function burn(uint256 tokenId) external whenNotPaused {
        require(super._isApprovedOrOwner(msg.sender, tokenId), "forbid");
        super._burn(tokenId);
    }

    function setBaseURI(string memory baseURI_) external onlyOwner {
        baseURI = baseURI_;
    }

    function setSigner(address account) external onlyOwner {
        signer = account;
    }

    function setTransferable() external onlyOwner {
        transferable = !transferable;
    }

    function pause() external onlyOwner {
        super._pause();
    }

    function unpause() external onlyOwner {
        super._unpause();
    }
}
