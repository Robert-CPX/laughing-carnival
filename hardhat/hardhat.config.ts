import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const config: HardhatUserConfig = {
  solidity: "0.8.19",
  networks: {
    hardhat: {
      chainId: 1337,
    },
    // polygon_mumbai: {
    //   url: "hhttps://rpc-mumbai.maticvigil.com"",
    //   accounts: [process.env.pk]
    // },
  },
};

export default config;
