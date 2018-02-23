pragma solidity ^0.4.18;
import "zeppelin-solidity/contracts/token/ERC20/StandardToken.sol";
import "zeppelin-solidity/contracts/ownership/Ownable.sol";

contract EmpowerCoin is StandardToken, Ownable {
  string public name = "EmpowerCoin"; 
  string public symbol = "EMP";
  uint public decimals = 2;
  uint public INITIAL_SUPPLY = 10000 * (10 ** decimals);
  event TokensIssued(address indexed issuer, address indexed reciever, uint256 amount);

  mapping(address => bool) internal suppliers;

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

  function issueTokens(address reciever, uint256 amount) onlySuppliers public {
    balances[reciever] = balances[reciever].add(amount);
    TokensIssued(msg.sender, reciever, amount);
  }
}