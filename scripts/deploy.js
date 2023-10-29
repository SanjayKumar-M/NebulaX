const hre = require("hardhat")

const main =  async() =>{
  const Nebulaxcontract = await hre.ethers.getContractFactory("Nebulax")

  const deployContract = await Nebulaxcontract.deploy('0xF75362E0484D6B1A50cb723143C0344ca2a04465'); 
  await deployContract.waitForDeployment();
  
  console.log(`Contract deployed successfully to ${deployContract.target}`);
}
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});