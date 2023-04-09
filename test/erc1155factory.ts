import { ethers } from "hardhat";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { StandsolutionsERC1155Factory } from "../types/StandsolutionsERC1155Factory";

const ZERO_ADDRESS = ethers.constants.AddressZero;
const SIGNER = "0x941530Ddf339f6c47e4B39Ae5E419541E5b8f0A5";
const BASEURI = "http://localhost";
const TRANSFERABLE = true

describe("StandsolutionsERC1155Factory contract", function () {
  let accounts: SignerWithAddress[];
  let contract: StandsolutionsERC1155Factory;
  beforeEach(async () => {
    accounts = await ethers.getSigners();

    const contractFactory = await ethers.getContractFactory("StandsolutionsERC1155Factory");
    contract = (await contractFactory.deploy(SIGNER)) as StandsolutionsERC1155Factory;
    await contract.deployed();
    contract = contract.connect(accounts[0]);
  });

  describe("create ERC1155", () => {
    it("should emit StandsolutionsERC1155Created event", async () => {
      const uri = "http://localhost";
      await expect(await contract.createStandsolutionsERC1155(BASEURI, TRANSFERABLE))
        .to.emit(contract, "StandsolutionsERC1155Created");
    });
  });
});
