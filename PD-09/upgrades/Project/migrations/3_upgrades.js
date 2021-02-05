const { deployProxy, upgradeProxy } = require('@openzeppelin/truffle-upgrades');

var Oracle = artifacts.require("Oracle");
var CCMachine = artifacts.require("CryptoCoinMachine");
var CCMachineDeux = artifacts.require("CryptoCoinMachine2");

module.exports = async function (deployer) {
  const Orc = await Oracle.deployed();
  const CCMachineContract = await CCMachine.deployed();
  const CCMContractDeux = await upgradeProxy(CCMachineContract.address, CCMachineDeux, { deployer, initializer: 'initialize' });
  console.log(`Address of CCMachineContract: ${CCMachineContract.address}`);
  console.log(`Address of CCMContractDeux: ${CCMContractDeux.address}`);
  var balanceAddress = await CCMContractDeux.CCMachineBalance();
  console.log(`Balance of CCMContractDeux: ${balanceAddress}`);
};
