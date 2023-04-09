import {ethers} from "hardhat";

const FACTORY_ADDRESS = '0x941530Ddf339f6c47e4B39Ae5E419541E5b8f0A5';
const BASEURI = 'https://arweave.net/';
const TRANSFERABLE = true

async function main() {
  const [account] = await ethers.getSigners();

  console.log("Account:", account.address);
  console.log("Balance:", (await account.getBalance()).toString());

  const Factory = await ethers.getContractFactory("StandsolutionsERC1155Factory");
  const contract = await Factory.attach(FACTORY_ADDRESS);

  const tx = await contract.createPort3ERC1155(BASEURI, TRANSFERABLE);
  await tx.wait();
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
