const ERC20Basic = artifacts.require("ERC20Basic");
const Ownable = artifacts.require("Ownable");
const BasicToken = artifacts.require("BasicToken");
const ERC20 = artifacts.require("ERC20");
const StandardToken = artifacts.require("StandardToken");
const MintableToken = artifacts.require("MintableToken");
const SafeMath = artifacts.require("SafeMath");
const Pausable = artifacts.require("Pausable");
const Crowdsale = artifacts.require("Crowdsale");
const FinalizableCrowdsale = artifacts.require("FinalizableCrowdsale");
const RefundVault = artifacts.require("RefundVault");
const RefundableCrowdsale = artifacts.require("RefundableCrowdsale");
const Dayta = artifacts.require("Dayta");
const DaytaCrowdsale = artifacts.require("DaytaCrowdsale");

module.exports = function(deployer) {
  deployer.deploy(ERC20Basic);
  deployer.deploy(Ownable);
  deployer.deploy(BasicToken);
  deployer.deploy(ERC20);
  deployer.deploy(StandardToken);
  deployer.deploy(MintableToken);
  deployer.deploy(SafeMath);
  deployer.deploy(Pausable);
  deployer.deploy(Crowdsale);
  deployer.deploy(FinalizableCrowdsale);
  deployer.deploy(FinalizableCrowdsale);
  deployer.deploy(RefundVault);
  deployer.deploy(RefundableCrowdsale);
  deployer.deploy(Dayta);
  deployer.deploy(DaytaCrowdsale);
};