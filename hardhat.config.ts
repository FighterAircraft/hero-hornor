import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const { alchemyApiKey, mnemonic } = require('./secrets.json');

module.exports = {
      networks: {
       goerli: {
         url: `https://eth-goerli.alchemyapi.io/v2/${alchemyApiKey}`,
         accounts: { mnemonic: mnemonic },
       },
     },
    }

const config: HardhatUserConfig = {
  solidity: "0.8.9",
};

export default config;
