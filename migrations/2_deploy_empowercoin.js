var EmpowerCoin = artifacts.require("./EmpowerCoin.sol");

module.exports = function(deployer) {
    deployer.deploy(EmpowerCoin);
  };