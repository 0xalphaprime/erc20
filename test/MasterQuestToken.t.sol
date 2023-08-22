// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "../forge-std/Test.sol";
import {DeployToken} from "../script/DeployToken.s.sol";
import {MasterQuestToken} from "../src/MasterQuestToken.sol";

contract MasterQuestTokenTest is Test {
    MasterQuestToken public masterQuestToken;
    DeployToken public deployer;

    address alex = makeAddr("alex");
    address bee = makeAddr("bee");

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployToken();
        masterQuestToken = deployer.run();

        vm.prank(msg.sender);
        masterQuestToken.transfer(bee, STARTING_BALANCE);
    }

    function testBeeBalance() public {
        assertEq(STARTING_BALANCE, masterQuestToken.balanceOf(bee));
    }

    function testAllowanceWorks() public {
        uint256 initialAllowance = 1000;

        vm.prank(bee);
        masterQuestToken.approve(alex, initialAllowance);

        uint256 transferAmount = 100;

        vm.prank(alex);
        masterQuestToken.transferFrom(bee, alex, transferAmount);

        assertEq(masterQuestToken.balanceOf(alex), transferAmount);
        assertEq(
            masterQuestToken.balanceOf(bee),
            STARTING_BALANCE - transferAmount
        );
    }
}
