pragma solidity ^0.4.18;
import "zeppelin-solidity/contracts/token/ERC20/StandardToken.sol";
import "zeppelin-solidity/contracts/ownership/Ownable.sol";

// TODO: total supply and intial supply doesnt make much sense here. Let's fix that
contract EmpowerCoin is StandardToken, Ownable {

  struct PlasticWasteRegistration {
    uint32 tokensIssued;
    uint32 kgOfPlasticWaste;
    string datetime;
    string location;
  }

  string public name = "EmpowerCoin"; 
  string public symbol = "EMP";
  uint32 public decimals = 2;
  uint public INITIAL_SUPPLY = 10000 * (10 ** decimals);
  event TokensIssued(address indexed issuer, address indexed reciever, uint256 amount);
  event PlasticWasteRegistered(address indexed issues, address indexed reciever, PlasticWasteRegistration registration);

  mapping(address => bool) internal suppliers;
  mapping(address => PlasticWasteRegistration[]) internal plasticWasteRegistry;

  function EmpowerCoin() public {
    totalSupply_ = INITIAL_SUPPLY;
    balances[msg.sender] = INITIAL_SUPPLY;
    suppliers[msg.sender] = true;
  }

  modifier onlySuppliers() {
    require(suppliers[msg.sender]);
    _;
  }

  function registerSupplier(address supplier) onlyOwner public {
    suppliers[supplier] = true;
  }

  function deRegisterSupplier(address supplier) onlyOwner public {
    suppliers[supplier] = false;
  }

  function isRegisteredSupplier(address potentialSupplier) public view returns (bool) {
    return suppliers[potentialSupplier];
  }

  function isRegisteredSupplier() public view returns (bool) {
    return isRegisteredSupplier(msg.sender);
  }

  function getRegistrationsForUser(address user) public view returns (PlasticWasteRegistration[]) {
    return plasticWasteRegistry[user];
  }

    function getRegistrationsForUser() public view returns (PlasticWasteRegistration[]) {
    return getRegistrationsForUser(msg.sender);
  }

  function registerPlasticWaste(address addressToIssueTokensTo, uint32 kgOfPlasticWaste, string datetime, string location) onlySuppliers public {
    uint32 numberOfTokensToIssue = (kgOfPlasticWaste/10) * (10**decimals);
    PlasticWasteRegistration memory registration = PlasticWasteRegistration(numberOfTokensToIssue, kgOfPlasticWaste, datetime, location);
    plasticWasteRegistry[addressToIssueTokensTo].push(registration);
    PlasticWasteRegistered(msg.sender, addressToIssueTokensTo, registration);
    issueTokens(addressToIssueTokensTo, numberOfTokensToIssue);
  }

  // Temporary function to let us issue Tokens in case of errors in app or something similar
  function issueTokens(address reciever, uint256 amount) onlySuppliers public {
    balances[reciever] = balances[reciever].add(amount);
    TokensIssued(msg.sender, reciever, amount);
  }
}