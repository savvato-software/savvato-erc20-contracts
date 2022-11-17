const SavvatoERC20 = artifacts.require("SavvatoERC20");

module.exports = function(deployer) {
  deployer.deploy(SavvatoERC20, "MPJ Fund6", "MPJ");
};
