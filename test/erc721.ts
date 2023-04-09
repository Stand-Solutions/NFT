import { ethers } from "hardhat";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { StandsolutionsERC721 } from "../types/StandSolutionsERC721";

const ZERO_ADDRESS = ethers.constants.AddressZero;
const SIGNER = "0x941530Ddf339f6c47e4B39Ae5E419541E5b8f0A5";
const NAME = "name";
const SYMBOL = "symbol";
const BASEURI = "http://localhost";
const TRANSFERABLE = true

describe("StandsolutionsERC721 contract", function () {
  let accounts: SignerWithAddress[];
  let contract: StandsolutionsERC721;
  beforeEach(async () => {
    accounts = await ethers.getSigners();

    const contractFactory = await ethers.getContractFactory("StandsolutionsERC721");
    contract = (await contractFactory.deploy(NAME, SYMBOL, TRANSFERABLE)) as StandsolutionsERC721;
    await contract.deployed();
    contract = contract.connect(accounts[0]);
  });

  describe("mint NFT", () => {
    it("should emit StandsolutionsERC721Created event", async () => {
      await expect(await contract.mint(accounts[0].address, 1))
        .to.emit(contract, "StandsolutionsERC721Created");
    });
  });
});
