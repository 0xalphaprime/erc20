// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "../forge-std/Script.sol";
import {MasterQuestToken} from "../src/MasterQuestToken.sol";

contract DeployToken is Script {
    uint256 public constant INITIAL_SUPPLY = 100 ether;

    function run() external returns (MasterQuestToken) {
        vm.startBroadcast();
        MasterQuestToken mq = new MasterQuestToken(INITIAL_SUPPLY);
        vm.stopBroadcast();
        return mq;
    }
}
