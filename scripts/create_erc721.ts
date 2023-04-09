import {ethers} from "hardhat";

const FACTORY_ADDRESS = '0x941530Ddf339f6c47e4B39Ae5E419541E5b8f0A5';
const ERC721_NAME = 'Standsolutions Baby';
const ERC721_SYMBOL = 'PB';
const BASE_URI = 'https://arweave.net/';
const TRANSFERABLE = true

async function main() {
  const [account] = await ethers.getSigners();

  console.log("Account:", account.address);
  console.log("Balance:", (await account.getBalance()).toString());

  const Factory = await ethers.getContractFactory("StandsolutionsERC721Factory");
  const contract = await Factory.attach(FACTORY_ADDRESS);

  const tx = await contract.createPort3ERC721(ERC721_NAME, ERC721_SYMBOL, BASE_URI, TRANSFERABLE);
  await tx.wait();
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
