var Oracle = artifacts.require("Oracle");
var CryptoCoinMachine = artifacts.require("CryptoCoinMachine");

module.exports = async function (deployer) {
  await deployer.deploy(Oracle);
  const Orc = await Oracle.deployed();
  await deployer.deploy(CryptoCoinMachine);
  const CCM = await CryptoCoinMachine.deployed();
  await CCM.SetOracle(Orc.address);
};
