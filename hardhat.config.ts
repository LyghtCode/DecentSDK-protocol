import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
require("dotenv").config();
import './tasks'

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.9",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  networks: {
    mainnet: {
      url: process.env.MAINNET_URL,
      accounts: [process.env.PRIVATE_KEY as string],
    },
    goerli: {
      url: process.env.GOERLI_URL,
      accounts: [process.env.PRIVATE_KEY as string]
    },
    polygon: {
      url: process.env.POLYGON_MAINNET_URL,
      accounts: [process.env.PRIVATE_KEY as string]
    },
    polygon_testnet: {
      url: process.env.POLYGON_TESTNET_URL,
      accounts: [process.env.PRIVATE_KEY as string]
    },
    optimism: {
      url: process.env.OPTIMISM_MAINNET_URL,
      accounts: [process.env.PRIVATE_KEY as string]
    },
    optimism_testnet: {
      url: process.env.OPTIMISM_TESTNET_URL,
      accounts: [process.env.PRIVATE_KEY as string]
    },
    arbitrum: {
      url: process.env.ARBITRUM_MAINNET_URL,
      accounts: [process.env.PRIVATE_KEY as string]
    },
    arbitrum_testnet: {
      url: process.env.ARBITRUM_TESTNET_URL,
      accounts: [process.env.PRIVATE_KEY as string]
    },
    telos: {
      url: process.env.ARBITRUM_MAINNET_URL,
      accounts: [process.env.PRIVATE_KEY as string]
    },
    telos_testnet: {
      url: process.env.TELOS_TESTNET_URL,
      accounts: [process.env.PRIVATE_KEY as string]
    },
  },
  etherscan: {
    apiKey: {
      mainnet: process.env.ETHERSCAN_KEY as string,
      goerli: process.env.ETHERSCAN_KEY as string,
      polygon: process.env.POLYGONSCAN_KEY as string,
      polygonMumbai: process.env.POLYGONSCAN_KEY as string,
      optimism_testnet: process.env.OPTIMISMSCAN_KEY as string,
      arbitrum_testnet: process.env.BLOCKSCOUT_KEY as string,
      telos: process.env.TELOSSCAN_KEY as string,
      telos_testnet: process.env.TELOSSCAN_KEY as string,   
    },
    customChains: [
      {
        network: "optimism_testnet",
        chainId: 420,
        urls: {
          apiURL: "https://api-goerli-optimism.etherscan.io/api",
          browserURL: "https://goerli-optimism.etherscan.io/"
        }
      },
      {
        network: "arbitrum_testnet",
        chainId: 421613,
        urls: {
          apiURL: "https://goerli-rollup-explorer.arbitrum.io/api",
          browserURL: "https://goerli-rollup-explorer.arbitrum.io"
        }
      },
      {
        network: "telos_testnet",
        chainId: 41,
        urls: {
          apiURL: "https://goerli-rollup-explorer.arbitrum.io/api",
          browserURL: "https://testnet.telos.net/evm"
        }
      },
    ],
  },
  gasReporter: {
    currency: 'USD',
    coinmarketcap: process.env.COINMARKETCAP_KEY,
    enabled: false
  },
};

export default config;
