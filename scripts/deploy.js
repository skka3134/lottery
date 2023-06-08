
async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);
    // const lottery  = await ethers.getContractFactory('Lottery ');
    // console.log('Deploying lottery...');
    // const lottery2  = await upgrades.deployProxy(lottery , [42], { initializer: 'store' });
    const lottery = await ethers.deployContract("Lottery");
    console.log('lottery deployed to:', lottery.address);
  }
  
  
  
  
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });