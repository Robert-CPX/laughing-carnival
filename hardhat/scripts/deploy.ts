import { ethers } from "hardhat";
import fs from "fs";

const main = async () => {
  const Blog = await ethers.getContractFactory("Blog");
  const blog = await Blog.deploy("My blog");

  await blog.deployed();
  console.log("Blog deployed to:", blog.address);
  const owner = await blog.signer.getAddress();
  fs.writeFileSync("./config.ts", `
  export const contractAddress = "${blog.address}"
  export const ownerAddress = "${owner}"
  `);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });