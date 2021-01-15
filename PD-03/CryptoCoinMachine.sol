pragma solidity ^0.8.0;

contract CryptoCoinMachine {
    
    mapping(address => uint[]) gamblers;
    uint[] public outcome;

    constructor() payable { }

    event earnProfits(bool profitable, uint profitAmount);
    
    function cryptoSpinned() public payable {
        require(msg.value > 0, "Insufficient balance");
        
        uint gamblerBalance = msg.value;
        
        uint randomCoin1 = outcome[0];
        uint randomCoin2 = outcome[1];
        uint randomCoin3 = outcome[2];
        
        gamblers[msg.sender] = outcome;
        
        //Profitable outcome 1: All BTC
        if (randomCoin1 == 1 &&
            randomCoin2 == 1 &&
            randomCoin3 == 1) {
            ProfitsCalculated(gamblerBalance, 50);
        }
        //Profitable outcome 2: All ETH
        if (randomCoin1 > 1 && randomCoin1 <= 4 &&
            randomCoin2 > 1 && randomCoin2 <= 4 &&
            randomCoin3 > 1 && randomCoin3 <= 4) {
            ProfitsCalculated(gamblerBalance, 40);
        }
        //Profitable outcome 3: All USDT
        if (randomCoin1 > 4 && randomCoin1 <= 9 &&
            randomCoin2 > 4 && randomCoin2 <= 9 &&
            randomCoin3 > 4 && randomCoin3 <= 9) {
            ProfitsCalculated(gamblerBalance, 30);
        }
        //Profitable outcome 4: All XRP
        if (randomCoin1 > 9 && randomCoin1 <= 16 &&
            randomCoin2 > 9 && randomCoin2 <= 16 &&
            randomCoin3 > 9 && randomCoin3 <= 16) {
            ProfitsCalculated(gamblerBalance, 20);
        }
        //Profitable outcome 5: All LTC
        if (randomCoin1 > 16 && randomCoin1 <= 25 &&
            randomCoin2 > 16 && randomCoin2 <= 25 &&
            randomCoin3 > 16 && randomCoin3 <= 25) {
            ProfitsCalculated(gamblerBalance, 10);
        }
        
        //Profitable outcome 6: coin1 = BTC, coin2 = ETH, coin3 = USDT
        if (randomCoin1 == 1 && 
            randomCoin2 > 1 && randomCoin2 <= 4 &&
            randomCoin3 > 4 && randomCoin3 <= 9) {
            ProfitsCalculated(gamblerBalance, 3);
        }
        //Profitable outcome 7: coin1 = ETH, coin2 = USDT, coin3 = XRP
        if (randomCoin1 > 1 && randomCoin1 <= 4 &&
            randomCoin2 > 4 && randomCoin2 <= 9 &&
            randomCoin3 > 9 && randomCoin3 <= 16) {
            ProfitsCalculated(gamblerBalance, 2);
        }
        //Profitable outcome 8: coin1 = USDT, coin2 = XRP, coin3 = LTC
        if (randomCoin1 > 4 && randomCoin1 <= 9 &&
            randomCoin2 > 9 && randomCoin2 <= 16 &&
            randomCoin3 > 16 && randomCoin3 <= 25) {
            ProfitsCalculated(gamblerBalance, 1);
        }
        //Unprofitable outcome: else
        else { ProfitsCalculated(gamblerBalance, 0); }
        
    }
    
    function Random() public view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.timestamp)))%5;
    }
    
    function ContractBalance() public view returns (uint) { return address(this).balance; }
    
    function ProfitsCalculated(uint gamblerBalance, uint multiplier) public {
        uint profits = gamblerBalance * multiplier;
        bool profitable = true;
        
        if (ContractBalance() < profits) profits = ContractBalance();
        payable(msg.sender).transfer(profits);
        emit earnProfits(profitable, profits);
    }
        
    function getOutcome() public view returns (uint[] memory) { return gamblers[msg.sender]; }
}
