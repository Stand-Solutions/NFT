import { HardhatUserConfig } from "hardhat/config";
import "@nomiclabs/hardhat-waffle";
import "tsconfig-paths/register";
import "@typechain/hardhat";
import "@nomiclabs/hardhat-ethers";
import "hardhat-gas-reporter";
import "solidity-coverage";
import '@openzeppelin/hardhat-upgrades';
import "@nomiclabs/hardhat-etherscan";

require("dotenv").config();

const privateKeys = (process.env.PRIVATE_KEYS ?? "").split(",")


const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.12",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  networks: {
    bsc_test: {
      url: process.env.BSC_TESTNET ?? "http://localhost:10002",
      accounts: [
        ...privateKeys,
      ],
      gas: 3000000,
      gasPrice: 10000000000,
    },
    bsc: {
      url: process.env.BSC_MAINNET ?? "http://localhost:10002",
      accounts: [
        ...privateKeys,
      ],
      gas: 3000000,
      gasPrice: 10000000000,
    },
    goerli: {
      url: process.env.RINKEBY ?? "http://localhost:10002",
      accounts: [
        ...privateKeys,
      ],
      gas: 3000000,
      gasPrice: 10000000000,
    },
  },
  etherscan: {
    apiKey: {
      bsc_test: '',
      bsc: '',
      rinkeby: '',
    },
  },
  gasReporter: {
    currency: "EUR",
    gasPrice: 21
  },
  typechain: {
    outDir: "types",
    target: "ethers-v5",
    alwaysGenerateOverloads: false,
    externalArtifacts: ["externalArtifacts/*.json"],
  },
};

export default config;
