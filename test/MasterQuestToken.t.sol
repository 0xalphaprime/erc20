// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {DeployToken} from "../script/DeployToken.s.sol";
import {MasterQuestToken} from "../src/MasterQuestToken.sol";
import {Test, console} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";

interface MintableToken {
    function mint(address, uint256) external;
}

contract MasterQuestTokenTest is StdCheats, Test {
    uint256 BOB_STARTING_AMOUNT = 100 ether;

    MasterQuestToken public masterQuestToken;
    DeployToken public deployer;
    address public deployerAddress;
    address bob;
    address alice;

    function setUp() public {
        deployer = new DeployToken();
        masterQuestToken = deployer.run();

        bob = makeAddr("bob");
        alice = makeAddr("alice");

        deployerAddress = vm.addr(deployer.deployerKey());
        vm.prank(deployerAddress);
        masterQuestToken.transfer(bob, BOB_STARTING_AMOUNT);
    }

    function testInitialSupply() public {
        assertEq(masterQuestToken.totalSupply(), deployer.INITIAL_SUPPLY());
    }

    function testUsersCantMint() public {
        vm.expectRevert();
        MintableToken(address(masterQuestToken)).mint(address(this), 1);
    }

    function testAllowances() public {
        uint256 initialAllowance = 1000;

        // Alice approves Bob to spend tokens on her behalf
        vm.prank(bob);
        masterQuestToken.approve(alice, initialAllowance);
        uint256 transferAmount = 500;

        vm.prank(alice);
        masterQuestToken.transferFrom(bob, alice, transferAmount);
        assertEq(masterQuestToken.balanceOf(alice), transferAmount);
        assertEq(
            masterQuestToken.balanceOf(bob),
            BOB_STARTING_AMOUNT - transferAmount
        );
    }

    // can you get the coverage up?
}
