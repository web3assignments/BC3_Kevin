const { deployProxy } = require('@openzeppelin/truffle-upgrades');

var CCMachine = artifacts.require("CryptoCoinMachine");
var Oracle = artifacts.require("Oracle");

module.exports = async function(deployer) {
    await deployer.deploy(Oracle);
    const CCMachineContract = await deployProxy(CCMachine, [], { deployer, initializer: 'initialize' });
    console.log(`Address of CCMachineContract: ${CCMachineContract.address}`);
    var balanceAddress = await CCMachineContract.CCMachineBalance();
    console.log(`Balance of CCMachineContract: ${balanceAddress}`);
}