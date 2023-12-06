const hre = require("hardhat")

const main =  async() =>{
  const Nebulaxcontract = await hre.ethers.getContractFactory("Nebulax")

  const deployeraddress = '0x514910771AF9Ca656af840dff83E8264EcF986CA';
  const recieveraddress = '0xa151660a77f223e87298de16ee5bb7447982b62f';


  const deployContract = await Nebulaxcontract.deploy(deployeraddress,recieveraddress); 
  await deployContract.waitForDeployment();
  
  console.log(`Contract deployed successfully to ${deployContract.target}`);
}
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});