import * as dotenv from 'dotenv'
import { HardhatUserConfig } from 'hardhat/config'
import '@nomicfoundation/hardhat-toolbox'

dotenv.config()

const config: HardhatUserConfig = {
  solidity: '0.8.18',

  networks: {
    // Add this block to enable the local network
    localhost: {
      url: 'http://127.0.0.1:8545'
    },
    sepolia: {
      chainId: 11155111,
      url: process.env.SEPOLIA_ALCHEMY_ENDPOINT || '',
      accounts:
        process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : []
    },
    testnetZkevm: {
      chainId: 1442,
      url: process.env.TESTNET_ZKEVM_ALCHEMY_ENDPOINT || '',
      accounts:
        process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : []
    }
  }
}

export default config
