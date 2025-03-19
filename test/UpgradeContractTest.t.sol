// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {Test} from "lib/forge-std/src/Test.sol";
import {BoxV1} from "src/BoxV1.sol";
import {BoxV2} from "src/BoxV2.sol";
import {DeployBoxContract} from "script/DeployBox.s.sol";
import {UpgradeBoxContract} from "script/UpgradeBox.s.sol";

contract UpgradeContractTest is Test {

    DeployBoxContract public deployer;
    UpgradeBoxContract public upgrader;
    address public owner = makeAddr("owner");
    address public proxy;
    address public upgraderAddr;

    function setUp() external {
        deployer = new DeployBoxContract();
        // proxy -> points to boxV1 contract
        (proxy) = deployer.run();

        upgrader = new UpgradeBoxContract();
        (upgraderAddr) = upgrader.run();
    }

    function test_ProxyStartsAsBox1() public {
        vm.expectRevert();
        BoxV2(proxy).setValue(20);
    }

    function testUpgrades() public {
        BoxV2 boxv2 = new BoxV2();

        vm.startPrank(msg.sender);
        upgrader.setUp(proxy, address(boxv2));
        vm.stopPrank();

        uint256 expectedVersion = 2;
        assert(expectedVersion == BoxV2(proxy).version());

        BoxV2(proxy).setValue(10);

        assert(BoxV2(proxy).getValue() == 10);
    }


}