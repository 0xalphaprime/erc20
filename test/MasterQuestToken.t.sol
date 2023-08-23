// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {DeployToken} from "../script/DeployToken.s.sol";
import {MasterQuestToken} from "../src/MasterQuestToken.sol";
import {Test, console} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";

contract MasterQuestTokenTest is StdCheats, Test {
    MasterQuestToken public masterQuestToken;
    DeployToken public deployer;

    function setUp() public {
        deployer = new DeployToken();
        masterQuestToken = deployer.run();
    }

    function testInitialSupply() public {
        assertEq(masterQuestToken.totalSupply(), deployer.INITIAL_SUPPLY());
    }

    function testAllowances() public {
        masterQuestToken.approve(msg.sender, 1000);
        assertEq(masterQuestToken.allowance(msg.sender, msg.sender), 1000);

        // Use allowance to transfer from the contract to a helper
        HelperBob bob = new HelperBob(masterQuestToken);
        bob.useAllowance(msg.sender, 500);
        assertEq(masterQuestToken.balanceOf(address(bob)), 500);
        assertEq(masterQuestToken.allowance(msg.sender, msg.sender), 500);
    }

    function testTransfers() public {
        // Transfer to a helper contract
        HelperAlice alice = new HelperAlice(masterQuestToken);
        alice.transferTokens(address(this), 1000);
        assertEq(masterQuestToken.balanceOf(address(alice)), 1000);
    }

    // Test functions that are expected to fail don't have expectRevert for now

    function testTransferMoreThanBalance() public {
        masterQuestToken.transfer(
            address(0x456),
            deployer.INITIAL_SUPPLY() + 1
        );
    }

    function testTransferFromMoreThanAllowed() public {
        masterQuestToken.approve(address(0x456), 500);
        masterQuestToken.transferFrom(address(this), address(0x789), 501);
    }

    function testNameAndSymbol() public {
        assertEq(masterQuestToken.name(), "masterQuest");
        assertEq(masterQuestToken.symbol(), "MQ");
    }

    function testDecimals() public {
        assertEq(masterQuestToken.decimals(), 18); // Assuming 18 decimals.
    }
}

contract HelperAlice {
    MasterQuestToken token;

    constructor(MasterQuestToken _token) {
        token = _token;
    }

    function transferTokens(address recipient, uint256 amount) public {
        token.transfer(recipient, amount);
    }
}

contract HelperBob {
    MasterQuestToken token;

    constructor(MasterQuestToken _token) {
        token = _token;
    }

    function useAllowance(address owner, uint256 amount) public {
        token.transferFrom(owner, address(this), amount);
    }
}
