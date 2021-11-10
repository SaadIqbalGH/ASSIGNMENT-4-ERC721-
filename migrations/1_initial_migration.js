const Migrations = artifacts.require("SaadCreations");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
};
