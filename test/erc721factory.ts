import { ethers } from "hardhat";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { StandsolutionsERC721Factory } from "../types/StandsolutionsERC721Factory";

const ZERO_ADDRESS = ethers.constants.AddressZero;
const SIGNER = "0x941530Ddf339f6c47e4B39Ae5E419541E5b8f0A5";
const BASEURI = "http://localhost";
const TRANSFERABLE = true

describe("StandsolutionsERC721Factory contract", function () {
  let accounts: SignerWithAddress[];
  let contract: StandsolutionsERC721Factory;
  beforeEach(async () => {
    accounts = await ethers.getSigners();

    const contractFactory = await ethers.getContractFactory("StandsolutionsERC721Factory");
    contract = (await contractFactory.deploy(SIGNER)) as StandsolutionsERC721Factory;
    await contract.deployed();
    contract = contract.connect(accounts[0]);
  });

  describe("create ERC721", () => {
    it("should emit StandsolutionsERC721Created event", async () => {
      const name = "name";
      const symbol = "symbol";
      await expect(await contract.createStandsolutionsERC721(name, symbol, BASEURI, TRANSFERABLE))
        .to.emit(contract, "StandsolutionsERC721Created");
    });
  });
});
