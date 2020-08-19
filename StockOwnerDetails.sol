pragma solidity >=0.4.22 <0.7.0;

import "./SafeMath.sol";
import "./Ownable.sol";

contract StockOwnerDetails is Ownable{
    event StockTrade(string description,bool flag);
    event ContractCreation(string description, address contractAddress);
    
    struct StockDetails{
        string stockName;
        uint256 numOfShares;
        uint256 amountOfMoneySpent;
        bool isAvailable;
        uint256 index;
    }
    
    mapping(address=>StockDetails) public stockOwnerDetailsMapping;
    address[] public addressOfOwners; // reference for the mapping 

    using SafeMath for SafeMath;

    constructor() public {
        owner = msg.sender;
        emit ContractCreation("ContractCreated",address(this));
    }
    
    function storeStockOwnerDetails(string memory _stockName,uint _numberOfShares,uint _amountOfMoneySpent) public payable {
        require(msg.value == _amountOfMoneySpent,"Amount sent and amount said is not equal");
        require(msg.value > 10,"Minimum stock amount is 10wei");
        if(checkForAvailability(msg.sender) == false){
            addressOfOwners.push(msg.sender);
            stockOwnerDetailsMapping[msg.sender].isAvailable=true;
            stockOwnerDetailsMapping[msg.sender].index = (addressOfOwners.length)-1;
        }
        stockOwnerDetailsMapping[msg.sender].stockName = _stockName;
        SafeMath.add(stockOwnerDetailsMapping[msg.sender].numOfShares,_numberOfShares);
        stockOwnerDetailsMapping[msg.sender].numOfShares += _numberOfShares;
        stockOwnerDetailsMapping[msg.sender].amountOfMoneySpent += _amountOfMoneySpent;
        emit StockTrade("Sucessfully bought",true);
    }
    
    function retrieveStockOwnerDetails(address _stockOwnerAddress) public view returns (string memory _stockName,uint _numberOfShares,uint _amountOfMoneySpent){
        _stockName =stockOwnerDetailsMapping[_stockOwnerAddress].stockName;
        _numberOfShares = stockOwnerDetailsMapping[_stockOwnerAddress].numOfShares;
         _amountOfMoneySpent = stockOwnerDetailsMapping[_stockOwnerAddress].amountOfMoneySpent;
    }
    
    function retieveAddressOfOwner() public view returns (address[] memory){
        return addressOfOwners;
    }
    
    function checkForAvailability(address _addressOfStockOwner) public view returns(bool){
        return stockOwnerDetailsMapping[_addressOfStockOwner].isAvailable;
    }
    
}
