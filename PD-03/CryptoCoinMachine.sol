pragma solidity ^0.6.11;

contract CryptoCoinMachine {
    
    mapping(address => uint[]) gamblers;
    string[] public cryptoCoins = ["BTC", "ETH", "USDT", "XRP", "LTC"];
    uint[3] public outcome;

    constructor() public payable { }

    event earnProfits(bool profitable, uint profitAmount);
    
    function cryptoSpinned() public payable {
        require(msg.value > 0, "Insufficient amount");
        
        uint amount = msg.value;
        uint gamblerBalance = amount;
        delete outcome;
        
        uint randomCoin = Random();
        outcome.push(cryptoCoins[randomCoin]);
        uint randomCoin2 = Random();
        outcome.push(cryptoCoins[randomCoin2]);
        uint randomCoin3 = Random();
        outcome.push(cryptoCoins[randomCoin3]);
        
        gamblers[msg.sender] = outcome;
        
        //initiate coinGenerators
    }
    
    function Random() public view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.timestamp)))%5;
    }
    
    function ContractBalance() public view returns (uint) { return address(this).balance; }
    
    function ProfitsCalculated(uint profit, uint multiplier) private {
        uint profits = profit * multiplier;
        bool profitable = true;
        
        if (ContractBalance() < profits) profits = ContractBalance();
        msg.sender.transfer(profits);
        emit earnProfits(profitable, profits);
    }
        
    function getOutcome() public view returns (uint[] memory) { return gamblers[msg.sender]; }
}
