// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "@openzeppelin/upgrades-core/contracts/Initializable.sol";
import "./Oracle.sol";

contract CryptoCoinMachine2 is Initializable {
    mapping(address => uint[]) gamblers;
    uint[] public outcomes;
    address public oracle;
    address private owner;

    function initialize() public payable initializer {
        owner = 0xa7C81b03Fafe4775c3d3826f11C1f36fA07b7530;
    }

    constructor() public payable { }

    event earnProfits(bool profitable, uint profitAmount);

    modifier sufficientStake(uint _stake) {
        require(msg.value >= _stake,  "Minimum stake is 1 ether");
        _;
        }

    function SetOracle(address _address) public { oracle = address(_address); }
    function GetOracle() public returns (bytes32) {
        Oracle orc = Oracle(oracle);
        return orc.GetRandomNr();
    }
    function GetOracleNr() internal view returns (uint) {
        Oracle orc = Oracle(oracle);
        return orc.GetOracleNr();
    }
    function OracleNrProcessed(uint nr) internal returns (uint[3] memory) {
        uint[3] memory array;
        uint[3] memory randomNr;
        
        for (uint i = 0; i < 3; i++) {
            uint digit = nr % 10000;
            array[i] = digit;
            nr /= 10000;
            randomNr[i] = digit % 23;
        }
        return randomNr;
    }
    function OutcomeProcessed() public { gamblers[msg.sender] = OracleNrProcessed(GetOracleNr()); }
    
    function CryptoSpinned() sufficientStake(1 ether) public payable {
        uint gamblerBalance = msg.value;
        
        uint randomCoin1 = outcomes[0];
        uint randomCoin2 = outcomes[1];
        uint randomCoin3 = outcomes[2];
        
        gamblers[msg.sender] = outcomes;
        
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
            ProfitsCalculated(gamblerBalance, 5);
        }
        //Profitable outcome 7: coin1 = ETH, coin2 = USDT, coin3 = XRP
        if (randomCoin1 > 1 && randomCoin1 <= 4 &&
            randomCoin2 > 4 && randomCoin2 <= 9 &&
            randomCoin3 > 9 && randomCoin3 <= 16) {
            ProfitsCalculated(gamblerBalance, 3);
        }
        //Profitable outcome 8: coin1 = USDT, coin2 = XRP, coin3 = LTC
        if (randomCoin1 > 4 && randomCoin1 <= 9 &&
            randomCoin2 > 9 && randomCoin2 <= 16 &&
            randomCoin3 > 16 && randomCoin3 <= 25) {
            ProfitsCalculated(gamblerBalance, 2);
        }
        //Profitable outcome 9: coin1 = XRP, coin2 = LTC, coin3 = BTC
        if (randomCoin1 > 9 && randomCoin1 <= 16 &&
            randomCoin2 > 16 && randomCoin2 <= 25 &&
            randomCoin3 == 1) {
            ProfitsCalculated(gamblerBalance, 4);
        }
        //Profitable outcome 10: coin1 = LTC, coin2 = BTC, coin3 = ETH
        if (randomCoin1 > 16 && randomCoin1 <= 25 &&
            randomCoin2 == 1 &&
            randomCoin3 > 1 && randomCoin3 <= 4) {
            ProfitsCalculated(gamblerBalance, 4);
        }
        
        //Unprofitable outcome: else
        else { ProfitsCalculated(gamblerBalance, 0); }
    }
    
    function CCMachineBalance() public view returns (uint) { return address(this).balance + 1; }
    
    function ProfitsCalculated(uint gamblerBalance, uint multiplier) public {
        uint profits = gamblerBalance * multiplier;
        bool profitable = true;
        
        if (CCMachineBalance() < profits) profits = CCMachineBalance();
        payable(msg.sender).transfer(profits);
        emit earnProfits(profitable, profits);
    }
        
    function GetOutcomes() public view returns (uint[] memory) { return gamblers[msg.sender]; }

}
