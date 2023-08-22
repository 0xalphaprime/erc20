// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {ERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract MasterQuestToken is ERC20 {
    constructor(uint256 ititialSupply) ERC20("masterQuest", "MQ") {
        _mint(msg.sender, ititialSupply);
    }
}
