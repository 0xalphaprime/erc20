// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "../forge-std/Script.sol";
import {MasterQuestToken} from "../src/MasterQuestToken.sol";
import {console} from "../forge-std/Console.sol";

contract DeployToken is Script {
    uint256 public constant INITIAL_SUPPLY = 100000 ether;
    uint256 public deployerKey;
    uint256 public DEFAULT_ANVIL_PRIVATE_KEY =
        0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;

    function run() external returns (MasterQuestToken) {
        if (block.chainid == 31337) {
            deployerKey = DEFAULT_ANVIL_PRIVATE_KEY;
        } else {
            deployerKey = vm.envUint("SEPOLIA_PRIVATE_KEY");
        }

        vm.startBroadcast(deployerKey);
        MasterQuestToken masterQuest = new MasterQuestToken(INITIAL_SUPPLY);
        vm.stopBroadcast();
        return masterQuest;
    }
}
