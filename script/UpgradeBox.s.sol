// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {Script} from "lib/forge-std/src/Script.sol";
import {BoxV2} from "src/BoxV2.sol";
import {BoxV1} from "src/BoxV1.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract UpgradeBoxContract is Script{
    BoxV2 box;

    function setUp(address _proxyAddress,address _boxAddr) public returns(address){
        vm.startBroadcast();
        BoxV1 proxy = BoxV1(_proxyAddress);
        proxy.upgradeToAndCall(_boxAddr,"");
        vm.stopBroadcast();

        return address(proxy);
    }

    function run() external returns(address){
        address proxyAddress = DevOpsTools.get_most_recent_deployment("ERC1967Proxy", block.chainid);
        vm.startBroadcast();
        box = new BoxV2();
        vm.stopBroadcast();

        address proxy = setUp(proxyAddress,address(box));

        return (proxy);
    }
}