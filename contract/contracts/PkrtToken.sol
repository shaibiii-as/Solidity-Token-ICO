// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/179
 */

abstract contract ERC20Basic {
  constructor() public { }
  function totalSupply() public view virtual returns (uint256);
  function balanceOf(address who) public view virtual returns (uint256);
  function transfer(address to, uint256 value) public virtual returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}



/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;


  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
   
  constructor() public {
      owner = msg.sender;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    emit OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

}




/**
 * @title Basic token
 * @dev Basic version of StandardToken, with no allowances.
 */
contract BasicToken is ERC20Basic {
  using SafeMath for uint256;

  mapping(address => uint256) balances;

  uint256 totalSupply_;

  /**
  * @dev total number of tokens in existence
  */
  function totalSupply() public view override returns (uint256) {
    return totalSupply_;
  }

  /**
  * @dev transfer token for a specified address
  * @param _to The address to transfer to.
  * @param _value The amount to be transferred.
  */
  function transfer(address _to, uint256 _value) public override returns (bool) {
    require(_to != address(0));
    require(_value <= balances[msg.sender]);

    // SafeMath.sub will throw if there is not enough balance.
    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    emit Transfer(msg.sender, _to, _value);
    return true;
  }

  function balanceOf(address _owner) public view override returns (uint256 balance) {
    return balances[_owner];
  }

}


/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
abstract contract ERC20 is ERC20Basic {
  function allowance(address owner, address spender) public view virtual returns (uint256);
  function transferFrom(address from, address to, uint256 value) public virtual returns (bool);
  function approve(address spender, uint256 value) public virtual returns (bool);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}



/**
 * @title Standard ERC20 token
 *
 * @dev Implementation of the basic standard token.
 * @dev https://github.com/ethereum/EIPs/issues/20
 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 */
contract StandardToken is ERC20, BasicToken {

  mapping (address => mapping (address => uint256)) internal allowed;


  /**
   * @dev Transfer tokens from one address to another
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _value uint256 the amount of tokens to be transferred
   */
  function transferFrom(address _from, address _to, uint256 _value) public override returns (bool) {
    require(_to != address(0));
    require(_value <= balances[_from]);
    require(_value <= allowed[_from][msg.sender]);

    balances[_from] = balances[_from] - _value;
    balances[_to] = balances[_to] + _value;
    allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;
    emit Transfer(_from, _to, _value);
    return true;
  }

  /**
   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
   *
   * Beware that changing an allowance with this method brings the risk that someone may use both the old
   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   * @param _spender The address which will spend the funds.
   * @param _value The amount of tokens to be spent.
   */
  function approve(address _spender, uint256 _value) public override returns (bool) {
    allowed[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    return true;
  }

  /**
   * @dev Function to check the amount of tokens that an owner allowed to a spender.
   * @param _owner address The address which owns the funds.
   * @param _spender address The address which will spend the funds.
   * @return A uint256 specifying the amount of tokens still available for the spender.
   */
  function allowance(address _owner, address _spender) public view override returns (uint256) {
    return allowed[_owner][_spender];
  }

  /**
   * @dev Increase the amount of tokens that an owner allowed to a spender.
   *
   * approve should be called when allowed[_spender] == 0. To increment
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param _spender The address which will spend the funds.
   * @param _addedValue The amount of tokens to increase the allowance by.
   */
  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
    allowed[msg.sender][_spender] = allowed[msg.sender][_spender] + _addedValue;
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

  /**
   * @dev Decrease the amount of tokens that an owner allowed to a spender.
   *
   * approve should be called when allowed[_spender] == 0. To decrement
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param _spender The address which will spend the funds.
   * @param _subtractedValue The amount of tokens to decrease the allowance by.
   */
  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
    uint oldValue = allowed[msg.sender][_spender];
    if (_subtractedValue > oldValue) {
      allowed[msg.sender][_spender] = 0;
    } else {
      allowed[msg.sender][_spender] = oldValue - _subtractedValue;
    }
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

}




/**
 * @title Mintable token
 * @dev Simple ERC20 Token example, with mintable token creation
 * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
 * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
 */
contract MintableToken is StandardToken, Ownable {
  event Mint(address indexed to, uint256 amount);
  event MintFinished();

  bool public mintingFinished = false;


  modifier canMint() {
    require(!mintingFinished);
    _;
  }

  /**
   * @dev Function to mint tokens
   * @param _to The address that will receive the minted tokens.
   * @param _amount The amount of tokens to mint.
   * @return A boolean that indicates if the operation was successful.
   */
  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
    totalSupply_ = totalSupply_ + _amount;
    balances[_to] = balances[_to] + _amount;
    emit Mint(_to, _amount);
    emit Transfer(address(0), _to, _amount);
    return true;
  }

  /**
   * @dev Function to stop minting new tokens.
   * @return True if the operation was successful.
   */
  function finishMinting() onlyOwner canMint public returns (bool) {
    mintingFinished = true;
    emit MintFinished();
    return true;
  }

  function burnTokens(uint256 _unsoldTokens) onlyOwner public returns (bool) {
    totalSupply_ = SafeMath.sub(totalSupply_, _unsoldTokens);
  }
}




/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal view returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal view returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  /**
  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal view returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal view returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}




/**
 * @title Pausable
 * @dev Base contract which allows children to implement an emergency stop mechanism.
 */
contract Pausable is Ownable {
  event Pause();
  event Unpause();

  bool public paused = false;


  /**
   * @dev Modifier to make a function callable only when the contract is not paused.
   */
  modifier whenNotPaused() {
    require(!paused);
    _;
  }

  /**
   * @dev Modifier to make a function callable only when the contract is paused.
   */
  modifier whenPaused() {
    require(paused);
    _;
  }

  /**
   * @dev called by the owner to pause, triggers stopped state
   */
  function pause() onlyOwner whenNotPaused public {
    paused = true;
    emit Pause();
  }

  /**
   * @dev called by the owner to unpause, returns to normal state
   */
  function unpause() onlyOwner whenPaused public {
    paused = false;
    emit Unpause();
  }
}



/*
 * @title Crowdsale
 * @dev Crowdsale is a base contract for managing a token crowdsale.
 * Crowdsales have a start and end timestamps, where investors can make
 * token purchases and the crowdsale will assign them tokens based
 * on a token per ETH rate. Funds collected are forwarded to a wallet
 * as they arrive.
 */

contract Crowdsale is Ownable, Pausable {
  using SafeMath for uint256;
  // The token being sold
  MintableToken private token;
  // start and end timestamps where investments are allowed (both inclusive)
  uint256 public preStartTime;
  uint256 public preEndTime;
  uint256 public ICOstartTime;
  uint256 public ICOEndTime;

  // Bonuses will be calculated here of ICO and Pre-ICO (both inclusive)
  // will add cehck for permanent false, --- we are not using PRE ICO
  // uint256 public preICOBonus;       // 20%
  
  uint256 public firstWeekBonus;    // 15%
  uint256 public secondWeekBonus;   // 10%
  uint256 public thirdWeekBonus;    // 5%
  uint256 public forthWeekBonus;    // 1%
  uint256 public referalBonus;    // 100
  
  uint256 public firstWeekSupply;    // 12%
  uint256 public secondWeekSupply;   // 10%
  uint256 public thirdWeekSupply;    // 8%
  uint256 public forthWeekSupply;    // 5%
  uint256 public mainSupply;    // 100


  // wallet address where funds will be saved
  address internal wallet;
  // base-rate of a particular Dayta token
  uint256 public rate;
  // amount of raised money in wei
  uint256 public weiRaised; // internal
  // NOW Time UTC
  uint256 public nowTime;
  
  // Weeks in UTC
  uint256 public weekOne;
  uint256 public weekTwo;
  uint256 public weekThree;
  uint256 public weekForth;


  // total supply of token 
  uint256 public totalSupply = SafeMath.mul(1, 1 ether);


  // public Supply of token
  uint256 public publicSupply = SafeMath.mul(SafeMath.div(totalSupply,100),60);
  // ICO supply of token  --- updating ico supply to 60% (contributors)
  uint256 public icoSupply = SafeMath.mul(SafeMath.div(totalSupply,100),60);

  // preICO supply of token  ---  changing it to 0 as we are not giving pre ico  
  uint256 public preicoSupply = SafeMath.mul(SafeMath.div(totalSupply,100),0);           



  // new addition of structures for token division
  
  // Team supply of token 
  // Founders / Core Team
  uint256 public teamSupply = SafeMath.mul(SafeMath.div(totalSupply,100),12);

  // Charitable
  uint256 public charitySupply = SafeMath.mul(SafeMath.div(totalSupply,100),15);

  // Advisors
  uint256 public advisorSupply = SafeMath.mul(SafeMath.div(totalSupply,100),5);

  // Bounty Supply 
  uint256 public bountySupply = SafeMath.mul(SafeMath.div(totalSupply,100),3);

  // Bonus Supply 
  uint256 public bonusSupply = SafeMath.mul(SafeMath.div(totalSupply,100),5);


  // reserve supply of token  --- not needed
  // Reserved (business development, growth marketing, customer research, user experience / design)
  // uint256 public reserveSupply = SafeMath.mul(SafeMath.div(totalSupply,100),5);


  // partnerships supply of token  --- not needed
  // uint256 public partnershipsSupply = SafeMath.mul(SafeMath.div(totalSupply,100),10);



  // Time lock or vested period of token for team allocated token
  uint256 public teamTimeLock;
  // Time lock or vested period of token for partnerships allocated token
  uint256 public partnershipsTimeLock;
  // Time lock or vested period of token for reserve allocated token
  uint256 public reserveTimeLock;
  /*
   *  @bool checkBurnTokens
   *  @bool upgradeICOSupply  
  */
  bool public checkBurnTokens;
  bool public upgradeICOSupply;
  /*
   * event for token purchase logging
   * @param purchaser who paid for the tokens
   * @param beneficiary who got the tokens
   * @param value weis paid for purchase
   * @param amount amount of tokens purchased
   */
  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);

  // Dayta Crowdsale constructor
  constructor(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
    
    require(_startTime >= block.timestamp);
    require(_endTime >= _startTime);
    require(_rate > 0);
    require(_wallet != address(0));
    
    // Dayta token creation 
    token = createTokenContract();
    
    // Pre-ICO start Time
    preStartTime = _startTime;
    // Pre-ICO end time
    preEndTime = preStartTime + 30 days;
    // // ICO start Time
    ICOstartTime = preEndTime + 5 minutes;
    // ICO end Time
    ICOEndTime = _endTime;
    // Base Rate of SNCN Token
    rate = _rate;
    // Multi-sig wallet where funds will be saved
    wallet = _wallet;
    // Now time
    nowTime = block.timestamp;


    /* Calculations of Bonuses in Pre-ICO  -- Not Valid in this contract */ 
    // preICOBonus = SafeMath.div(SafeMath.mul(rate,20),100);



    firstWeekBonus = SafeMath.div(SafeMath.mul(rate,50),100);
    secondWeekBonus = SafeMath.div(SafeMath.mul(rate,25),100);
    thirdWeekBonus = SafeMath.div(SafeMath.mul(rate,15),100);
    forthWeekBonus = SafeMath.div(SafeMath.mul(rate,10),100);
    referalBonus  = 100;


    /* ICO bonuses week calculations */
    weekOne = SafeMath.add(ICOstartTime, 14 days);
    weekTwo = SafeMath.add(weekOne, 14 days);
    weekThree = SafeMath.add(weekTwo, 14 days);
    weekForth = SafeMath.add(weekThree, 14 days);


    /* Vested Period calculations for team and partnershipss*/
    teamTimeLock = SafeMath.add(ICOEndTime, 180 days);
    reserveTimeLock = SafeMath.add(ICOEndTime, 180 days);
    partnershipsTimeLock = SafeMath.add(preStartTime, 3 minutes);
    checkBurnTokens = false;
    upgradeICOSupply = false;
  }
  // creates the token to be sold.
  // override this method to have crowdsale of a specific mintable token.
  function createTokenContract() internal virtual returns (MintableToken) {
    return new MintableToken();
  }
  // fallback function can be used to buy tokens
  fallback () external payable  {
    buyTokens(msg.sender);
  }
  // High level token purchase function
  function buyTokens(address beneficiary) whenNotPaused public payable {
    require(beneficiary != address(0));
    require(validPurchase());
    uint256 weiAmount = msg.value;
    uint256 accessTime = block.timestamp;
    uint256 tokens = 0;
    require((weiAmount >= (1 * 1 ether)) && (weiAmount <= (50 * 1 ether)));


  // calculating the crowdsale and Pre-crowdsale bonuses on the basis of timing  --- commenting as there is no preICO 
    // if ((accessTime >= preStartTime) && (accessTime < preEndTime) && false) 
    // {
    //     require(preicoSupply > 0);
    //     tokens = SafeMath.add(tokens, weiAmount.mul(preICOBonus));  // 20% Tokens
    //     tokens = SafeMath.add(tokens, weiAmount.mul(rate));
    //     require(preicoSupply >= tokens);
    //     preicoSupply = preicoSupply.sub(tokens);
    //     publicSupply = publicSupply.sub(tokens);
    // } 
    // else 
    
    if ((accessTime >= ICOstartTime) && (accessTime <= ICOEndTime)) 
    {

        // --- pre ICO supply is set to 0
        // if (!upgradeICOSupply) 
        // {
        //   icoSupply = SafeMath.add(icoSupply,preicoSupply);
        //   upgradeICOSupply = true;
        // }
        
        if (accessTime <= weekOne) 
        { 
          tokens = SafeMath.add(tokens, weiAmount.mul(firstWeekBonus));
        } 
        else if (( accessTime <= weekTwo ) && (accessTime > weekOne)) 
        { 
          tokens = SafeMath.add(tokens, weiAmount.mul(secondWeekBonus));
        } 
        else if (( accessTime <= weekThree ) && (accessTime > weekTwo)) 
        {  
          tokens = SafeMath.add(tokens, weiAmount.mul(thirdWeekBonus));
        } 
        else if (( accessTime <= weekForth ) && (accessTime > weekThree)) 
        {  
          tokens = SafeMath.add(tokens, weiAmount.mul(forthWeekBonus));
        } 

        tokens = SafeMath.add(tokens, weiAmount.mul(rate));
        icoSupply = icoSupply.sub(tokens);      
        publicSupply = publicSupply.sub(tokens);  
    } 
    else if ((accessTime > preEndTime) && (accessTime < ICOstartTime)) 
    {
      revert();
    }
    // update state
    weiRaised = weiRaised.add(weiAmount);
    // tokens are minting here
    token.mint(beneficiary, tokens);
    emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
    // funds are forwarding
    forwardFunds();
  }
  // send ether to the fund collection wallet
  // override to create custom fund forwarding mechanisms
  function forwardFunds() virtual internal {
    address(uint160(wallet)).transfer(msg.value);
  }
  // @return true if the transaction can buy tokens
  function validPurchase() internal view returns (bool) {
    bool withinPeriod = block.timestamp >= preStartTime && block.timestamp <= ICOEndTime;
    bool nonZeroPurchase = msg.value != 0;
    return withinPeriod && nonZeroPurchase;
  }
  // @return true if crowdsale event has ended
  function hasEnded() public view returns (bool) {
      return block.timestamp > ICOEndTime;
  }
  function burnToken() onlyOwner  public returns (bool) {
    require(hasEnded());
    require(!checkBurnTokens);
    token.burnTokens(icoSupply);
    totalSupply = SafeMath.sub(totalSupply, publicSupply);
    preicoSupply = 0;
    icoSupply = 0;
    publicSupply = 0; 
    checkBurnTokens = true;
    return true;
  }
  function transferFunds(address[] memory recipients, uint256[] memory values) onlyOwner  public {
     require(!checkBurnTokens);
     for (uint256 i = 0; i < recipients.length; i++) {
        values[i] = SafeMath.mul(values[i], 1 ether);
        require(publicSupply >= values[i]);
        publicSupply = SafeMath.sub(publicSupply,values[i]);
        token.mint(recipients[i], values[i]); 
    }
  } 
  function bountyFunds(address[] memory recipients, uint256[] memory values) onlyOwner  public {
     require(!checkBurnTokens);
     for (uint256 i = 0; i < recipients.length; i++) {
        values[i] = SafeMath.mul(values[i], 1 ether);
        require(bountySupply >= values[i]);
        bountySupply = SafeMath.sub(bountySupply,values[i]);
        token.mint(recipients[i], values[i]); 
    }
  }
  function transferAdvisorFunds(address[] memory recipients, uint256[] memory values) onlyOwner  public {
     require(!checkBurnTokens);
     for (uint256 i = 0; i < recipients.length; i++) {
        values[i] = SafeMath.mul(values[i], 1 ether);
        require(advisorSupply >= values[i]);
        advisorSupply = SafeMath.sub(advisorSupply,values[i]);
        token.mint(recipients[i], values[i]); 
    }
  }
  function transferTeamTokens(address[] memory recipients, uint256[] memory values) onlyOwner  public {
    require(!checkBurnTokens);
    require((block.timestamp > teamTimeLock));
     for (uint256 i = 0; i < recipients.length; i++) {
        values[i] = SafeMath.mul(values[i], 1 ether);
        require(teamSupply >= values[i]);
        teamSupply = SafeMath.sub(teamSupply,values[i]);
        token.mint(recipients[i], values[i]); 
    }
  }
  function transferCharityTokens(address[] memory recipients, uint256[] memory values) onlyOwner  public {
    require(!checkBurnTokens);
    require((block.timestamp > teamTimeLock));
     for (uint256 i = 0; i < recipients.length; i++) {
        values[i] = SafeMath.mul(values[i], 1 ether);
        require(charitySupply >= values[i]);
        charitySupply = SafeMath.sub(charitySupply,values[i]);
        token.mint(recipients[i], values[i]); 
    }
  }

  // TODO: check, whats the issue --- commenting for now
  // function getTokenAddress() onlyOwner public returns (address) {
  //   return token;
  // }


  // function transferPartnershipsTokens(address[] recipients, uint256[] values) onlyOwner  public {
  //   require(!checkBurnTokens);
  //   require((reserveTimeLock < now));
  //    for (uint256 i = 0; i < recipients.length; i++) {
  //       values[i] = SafeMath.mul(values[i], 1 ether);
  //       require(partnershipsSupply >= values[i]);
  //       partnershipsSupply = SafeMath.sub(partnershipsSupply,values[i]);
  //       token.mint(recipients[i], values[i]); 
  //   }
  // }
  // function transferReserveTokens(address[] recipients, uint256[] values) onlyOwner  public {
  //   require(!checkBurnTokens);
  //   require((reserveTimeLock < now));
  //    for (uint256 i = 0; i < recipients.length; i++) {
  //       values[i] = SafeMath.mul(values[i], 1 ether);
  //       require(reserveSupply >= values[i]);
  //       reserveSupply = SafeMath.sub(reserveSupply,values[i]);
  //       token.mint(recipients[i], values[i]); 
  //   }
  // }
}




/**
 * @title FinalizableCrowdsale
 * @dev Extension of Crowdsale where an owner can do extra work
 * after finishing.
 */

abstract contract FinalizableCrowdsale is Crowdsale {
  using SafeMath for uint256;

  bool isFinalized = false;

  event Finalized();

  /**
   * @dev Must be called after crowdsale ends, to do some extra finalization
   * work. Calls the contract's finalization function.
   */
  function finalizeCrowdsale() onlyOwner public {
    require(!isFinalized);
    require(hasEnded());
    
    finalization();
    emit Finalized();
    
    isFinalized = true;
    }
  

  /**
   * @dev Can be overridden to add finalization logic. The overriding function
   * should call super.finalization() to ensure the chain of finalization is
   * executed entirely.
   */
  function finalization() virtual internal {
  }
}




/**
 * @title RefundVault
 * @dev This contract is used for storing funds while a crowdsale
 * is in progress. Supports refunding the money if crowdsale fails,
 * and forwarding it if crowdsale is successful.
 */
contract RefundVault is Ownable {
  using SafeMath for uint256;

  enum State { Active, Refunding, Closed }

  mapping (address => uint256) public deposited;
  address public wallet;
  State public state;

  event Closed();
  event RefundsEnabled();
  event Refunded(address indexed beneficiary, uint256 weiAmount);

  constructor(address _wallet) public {
    require(_wallet != address(0));
    wallet = _wallet;
    state = State.Active;
  }

  function deposit(address investor) onlyOwner public payable {
    require(state == State.Active);
    deposited[investor] = deposited[investor].add(msg.value);
  }

  // TODO: this funcion is mysterious --- check it later
  // function close() onlyOwner public {
  //   require(state == State.Active);
  //   state = State.Closed;
  //   emit Closed();
  //   wallet.transfer(address(this).balance);
  // }

  function enableRefunds() onlyOwner public {
    require(state == State.Active);
    state = State.Refunding;
    emit RefundsEnabled();
  }

  function refund(address payable investor) public {
    require(state == State.Refunding);
    uint256 depositedValue = deposited[investor];
    deposited[investor] = 0;
    investor.transfer(depositedValue);
    emit Refunded(investor, depositedValue);
  }
}




/**
 * @title RefundableCrowdsale
 * @dev Extension of Crowdsale contract that adds a funding goal, and
 * the possibility of users getting a refund if goal is not met.
 * Uses a RefundVault as the crowdsale's vault.
 */
abstract contract RefundableCrowdsale is FinalizableCrowdsale {
  using SafeMath for uint256;

  // minimum amount of funds to be raised in weis
  uint256 public goal;

  // refund vault used to hold funds while crowdsale is running
  RefundVault public vault;

  constructor(uint256 _goal) public {
    require(_goal > 0);
    vault = new RefundVault(wallet);
    goal = _goal;
  }

  // if crowdsale is unsuccessful, investors can claim refunds here
  function claimRefund() public {
    require(isFinalized);
    require(!goalReached());

    vault.refund(msg.sender);
  }

  function goalReached() public view returns (bool) {
    return weiRaised >= goal;
  }

  // vault finalization task, called when owner calls finalize()
  function finalization() override internal {
    if (goalReached()) {
      // vault.close();
    } else {
      vault.enableRefunds();
    }

    super.finalization();
  }

  // We're overriding the fund forwarding from Crowdsale.
  // In addition to sending the funds, we want to call
  // the RefundVault deposit function
  function forwardFunds() virtual override internal {
    // vault.deposit.value(msg.value)(msg.sender);

    vault.deposit.value(msg.value)(msg.sender);

  }

}



contract SDR is MintableToken {
  string public constant name = "DRC Token";
  string public constant symbol = "DRC";
  uint8 public constant decimals = 18;
  uint256 public totalSupplyTokens = SafeMath.mul(1 , 1 ether);
  
  constructor() public { 
    totalSupply_ = totalSupplyTokens;
  }
}


contract SDRCrowdsale is Crowdsale, RefundableCrowdsale {
    uint256 _startTime = 1547510400;                                            // January/15/2019 @ 12:00am (UTC)
    uint256 _endTime = 1557964740;                                              // 05/15/2019 @ 11:59pm (UTC)
    uint256 _rate = 33750;                                                      // 1 ETHER Price :: DAYTA TOKENS ::
    uint256 _goal = 3000 * 1 ether;                                             // SOFT CAP
    address _wallet = 0xfEcB6d19b40f72672c86A6EE54979E1c0253717f;               // WALLET ADDRESS 
 
      function forwardFunds() internal  override (Crowdsale, RefundableCrowdsale) {
      }

    /* Constructor DaytaCrowdsale */
    constructor() public
    FinalizableCrowdsale() 
    RefundableCrowdsale(_goal) 
    Crowdsale(_startTime,_endTime,_rate,_wallet)
    {

    }

    /*Dayta Contract is generating from here */
    function createTokenContract() internal override returns (MintableToken) {
        return new SDR();
    }
}