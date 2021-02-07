// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Oracle.sol";
import "./CryptoCoinMachine.sol";

contract CryptoCoinMachineTesting {
    CryptoCoinMachine ccm;

    function beforeAll() public {
        ccm = new CryptoCoinMachine();
    }
}