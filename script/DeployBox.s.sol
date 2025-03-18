// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {Script} from "lib/forge-std/src/Script.sol";
import {BoxV1} from "src/BoxV1.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract DeployBoxContract is Script{
    BoxV1 box;
    
    function setUp() public returns(address){
        vm.startBroadcast();
        // This will be our implementation contract
        box = new BoxV1(); 
        ERC1967Proxy proxy = new ERC1967Proxy(address(box),"");
        vm.stopBroadcast();

        return address(proxy);
    }

    function run() external returns(address){
        return setUp();
    }
}