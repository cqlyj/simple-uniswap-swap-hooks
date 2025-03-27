// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {OneTimeSwap} from "src/OneTimeSwap.sol";
import {Hooks} from "@openzeppelin/uniswap-hooks/lib/v4-core/src/libraries/Hooks.sol";
import {Currency} from "@openzeppelin/uniswap-hooks/lib/v4-core/src/types/Currency.sol";
import {Deployers} from "@openzeppelin/uniswap-hooks/lib/v4-core/test/utils/Deployers.sol";
import {IHooks} from "@openzeppelin/uniswap-hooks/lib/v4-core/src/interfaces/IHooks.sol";
import {LPFeeLibrary} from "@openzeppelin/uniswap-hooks/lib/v4-core/src/libraries/LPFeeLibrary.sol";
import {PoolSwapTest} from "@openzeppelin/uniswap-hooks/lib/v4-core/src/test/PoolSwapTest.sol";

contract OneTimeSwapTest is Test, Deployers {
    OneTimeSwap hook;

    function setUp() external {
        deployFreshManagerAndRouters();

        hook = OneTimeSwap(address(uint160(Hooks.BEFORE_SWAP_FLAG)));

        deployCodeTo(
            "OneTimeSwap.sol:OneTimeSwap",
            abi.encode(manager),
            address(hook)
        );

        deployMintAndApprove2Currencies();

        vm.label(Currency.unwrap(currency0), "currency0");
        vm.label(Currency.unwrap(currency1), "currency1");
    }

    function testOnlyOneSwapCanBeDone() external {
        (key, ) = initPoolAndAddLiquidity(
            currency0,
            currency1,
            IHooks(address(hook)),
            LPFeeLibrary.DYNAMIC_FEE_FLAG,
            SQRT_PRICE_1_1
        );

        assertEq(hook.s_swapDone(), false);

        PoolSwapTest.TestSettings memory settings = PoolSwapTest.TestSettings({
            takeClaims: false,
            settleUsingBurn: false
        });

        swapRouter.swap(key, SWAP_PARAMS, settings, ZERO_BYTES);

        assertEq(hook.s_swapDone(), true);

        vm.expectRevert();
        swapRouter.swap(key, SWAP_PARAMS, settings, ZERO_BYTES);
    }
}
