// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0; // meest recente versie van belang om array bij getOutcome terug te kunnen geven

contract CryptoCoinMachine {
    
    mapping(address => string[]) gamblers;
    string[] public cryptoCoins = ["BTC", "ETH", "USDT", "XRP", "LTC"];
    string[] public outcome; // naar type string omgezet, want de cryptoCoins zijn ook string. Tevens vaste grootte gegehaald, anders werkt push niet

    constructor() payable { }

    event earnProfits(bool profitable, uint profitAmount);
    
    function cryptoSpinned() public payable {
        require(msg.value > 0, "Insufficient amount");
        uint amount = msg.value;
        uint gamblerBalance = amount; // wordt niet gebruikt
        delete outcome;
        uint randomCoin = Random();
        outcome.push(cryptoCoins[randomCoin]);
        uint randomCoin2 = Random();
        outcome.push(cryptoCoins[randomCoin2]); // let op: geeft dezelfe waarde als randomCoin; omdat dit alles inhetzelfde block plaatsvindt.
        uint randomCoin3 = Random();
        outcome.push(cryptoCoins[randomCoin3]); // let op: geeft dezelfe waarde als randomCoin & randomCoin2; omdat dit alles inhetzelfde block plaatsvindt.
        gamblers[msg.sender] = outcome;
        //initiate coinGenerators
    }
    
    function Random() public view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.timestamp)))%5;
    }
    
    function ContractBalance() public view returns (uint) { return address(this).balance; }
    
    function ProfitsCalculated(uint profit, uint multiplier) public { // public gemaakt om te kunnen testen
        uint profits = profit * multiplier;
        bool profitable = true;
        
        if (ContractBalance() < profits) profits = ContractBalance();
        payable(msg.sender).transfer(profits); // typecast naar payable, nodig in recente solidity versies
        emit earnProfits(profitable, profits);
    }
        
    function getOutcome() public view returns (string[] memory) { return gamblers[msg.sender]; } // naar type string omgezet
}
