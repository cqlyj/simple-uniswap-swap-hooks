// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {Hooks} from "@openzeppelin/uniswap-hooks/lib/v4-core/src/libraries/Hooks.sol";
import {IPoolManager} from "@openzeppelin/uniswap-hooks/lib/v4-core/src/interfaces/IPoolManager.sol";
import {HookMiner} from "@v4-periphery/src/utils/HookMiner.sol";
import {OneTimeSwap} from "src/OneTimeSwap.sol";

// SEPOLIA TESTNET
contract DeployOneTimeSwap is Script {
    IPoolManager constant POOLMANAGER =
        IPoolManager(address(0xE03A1074c86CFeDd5C142C4F04F1a1536e203543));
    address constant CREATE2_DEPLOYER =
        0x4e59b44847b379578588920cA78FbF26c0B4956C;

    error HookAddressMismatch(address actual, address expected);

    function run() public {
        // hook contracts must have specific flags encoded in the address
        uint160 flags = uint160(Hooks.BEFORE_SWAP_FLAG);

        // Mine a salt that will produce a hook address with the correct flags
        bytes memory constructorArgs = abi.encode(POOLMANAGER);
        (address hookAddress, bytes32 salt) = HookMiner.find(
            CREATE2_DEPLOYER,
            flags,
            type(OneTimeSwap).creationCode,
            constructorArgs
        );

        // Deploy the hook using CREATE2
        vm.startBroadcast();
        OneTimeSwap oneTimeSwap = new OneTimeSwap{salt: salt}(
            IPoolManager(POOLMANAGER)
        );
        vm.stopBroadcast();

        if (address(oneTimeSwap) != hookAddress) {
            revert HookAddressMismatch(address(oneTimeSwap), hookAddress);
        }

        console.log("Hook deployed at", address(oneTimeSwap));
    }
}
