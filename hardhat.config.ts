import '@nomicfoundation/hardhat-chai-matchers';
import '@nomicfoundation/hardhat-ethers';
import '@typechain/hardhat';
import 'hardhat-spdx-license-identifier';
import { HardhatUserConfig } from 'hardhat/types';

const config: HardhatUserConfig = {
  solidity: {
    version: '0.8.21',
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },

  spdxLicenseIdentifier: {
    overwrite: true,
    runOnCompile: true,
  },
};

export default config;
