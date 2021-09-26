pragma solidity >=0.4.24 <0.8.0;

//create a contract that show ownership
contract owned {
    address  public owner;
    
    constructor(){
        owner = msg.sender;
        
    }
    
    modifier onlyOwner {
        require(msg.sender == owner, "I am the owner");
        _;
    }
    
    //This function enable transfer on ownership of the token 
    function transferOwnership (address newOwner) internal onlyOwner{
        owner = newOwner;
    }
   

}

contract TaroToken is owned {
    
    uint public totalSupply;
    string public constant name ='TARO';
    string public constant symbol ='TRO';
    uint8 public decimals =2;
   
    // mapping to hold all the balance
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    
    
    event Transfer(address indexed _from, address indexed _to, uint tokens);
    event Approval(address indexed _tokenOwner, address indexed _spender, uint tokens);
    event Burn(address indexed _from, uint256 _value);

    event Freeze(address account, string message);
    event unFreeze(address account, string message);
    
    // constructor that would hold the initial total Supply
    constructor ( uint initialSupply) public {
        totalSupply = initialSupply*10**uint256(decimals);
        balanceOf[msg.sender] = totalSupply;
       
    }
    
    // function that would hold the transfer to any address
    function _transfer(address _from, address _to, uint256 _value) internal {
        require(_to!= 0x0);
        // check the balance of the sender
        require(balanceOf[_from]>=_value);
        // to avoid overflow the transaction
        require(balanceOf[_to] + _value >= balanceOf[_to]);
        //transfer the money to the reciever 
        balanceOf[_from] -=_value;
        balanceOf[_to]+=_value;
        emit Transfer(_from, _to, _value);
    }
    // This function initial the transfer
    function transfer (address _to, uint256 _value) public returns (bool success){
        _transfer(msg.sender, _to, _value);
        return true;
    }
    
    function transferFrom(address _from, address _to, uint256 _value) public returns(bool success){
        require(_value <= allowance[_from][msg.sender]);
        allowance[_from][msg.sender] -= _value;
        _transfer(_from, _to, _value);
        return true;
    }
    
    // Ability to spend money e.g assuming your an employee of a company, the company may give some permission to spend from it company account
    function approve(address _spender, uint256 _value) public returns (bool success){
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    
    // Create new token  or mint
    function mintToken (address _target, uint256 _mintedAmount) internal onlyOwner{
        balanceOf[_target] += _mintedAmount;
        totalSupply += _mintedAmount;
        // emit Transfer(0, msg.sender, _mintedAmount);
        emit Transfer(msg.sender, _target, _mintedAmount);
    }
    
    // Function for burn the token
    function burn(uint256 _value) internal onlyOwner returns (bool success){
        require(balanceOf[msg.sender] >= _value);
        balanceOf[msg.sender] -= _value;
        totalSupply -= _value;
        emit Burn(msg.sender, _value);
        return true;
    }
    
    function freezAccount(address _account) internal onlyOwner {
        emit Freeze(_account, "The account was freeze successfully");
    }

    function unFreezAcc(address accounts) internal onlyOwner{
       emit unFreeze(accounts, "Account unfreez sucessfully");
    }    
}