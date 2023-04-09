// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract StandsolutionsERC1155 is ERC1155URIStorage, Ownable, Pausable {
    address public signer;
    bool public transferable;
    mapping(bytes32 => bool) public exists;

    constructor(string memory uri, bool limit) ERC1155(uri) {
        transferable = limit;
    }

    function _beforeTokenTransfer(address operator,address from,address to,uint256[] memory ids,uint256[] memory amounts,bytes memory data) internal virtual override {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
        require(transferable, "ERC1155: non transferable");
    }

    function mint(address to, uint256 id, uint256 amount, bytes calldata data) external onlyOwner {
        super._mint(to, id, amount, data);
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes calldata data) external onlyOwner {
        super._mintBatch(to, ids, amounts, data);
    }

    function singleMint(uint256 id, uint256 amount, bytes calldata data, uint256 deadline, bytes memory signature) external whenNotPaused {
        require(block.timestamp <= deadline, "expire");
        bytes32 digest = keccak256(abi.encode(msg.sender, id, amount, data, deadline));
        bytes32 hash = ECDSA.toEthSignedMessageHash(digest);
        require(ECDSA.recover(hash, signature) == signer, "invalid signer");
        require(!exists[digest], "already mint");
        exists[digest] = true;
        super._mint(msg.sender, id, amount, data);
    }

    function massMint(uint256[] memory ids, uint256[] memory amounts, bytes calldata data, uint256 deadline, bytes memory signature) external whenNotPaused {
        require(block.timestamp <= deadline, "expire");
        bytes32 digest = keccak256(abi.encode(msg.sender, ids, amounts, data, deadline));
        bytes32 hash = ECDSA.toEthSignedMessageHash(digest);
        require(ECDSA.recover(hash, signature) == signer, "invalid signer");
        require(!exists[digest], "already mint");
        exists[digest] = true;
        super._mintBatch(msg.sender, ids, amounts, data);
    }

    function burn(uint256 id, uint256 amount) external whenNotPaused {
        super._burn(msg.sender, id, amount);
    }

    function burnBatch(uint256[] memory ids, uint256[] memory amounts) external whenNotPaused {
        super._burnBatch(msg.sender, ids, amounts);
    }

    function setURI(string memory uri) external onlyOwner {
        super._setURI(uri);
    }

    function setBaseURI(string memory baseURI) external onlyOwner {
        super._setBaseURI(baseURI);
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
