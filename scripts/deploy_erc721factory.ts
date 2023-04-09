import {ethers} from "hardhat";

const SIGNER = "0xfa9E2F9bd8B8be7Ba7CE1526D9e0Fb3a262E6CfB";

async function main() {
  const [account] = await ethers.getSigners();

  console.log("Account:", account.address);
  console.log("Balance:", (await account.getBalance()).toString());

  const Contract = await ethers.getContractFactory("StandsolutionsERC721Factory");
  const contract = await Contract.deploy(SIGNER);
  console.log("Port3ERC721Factory deployed to:", contract.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
