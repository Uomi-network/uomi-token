const hre = require("hardhat");

async function main() {
  const uomi = await hre.ethers.deployContract("UOMI");

  await uomi.waitForDeployment();

  console.log("UOMI deployed to:", uomi.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
