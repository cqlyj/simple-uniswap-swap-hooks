// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {BaseHook, IPoolManager, Hooks, PoolKey} from "@openzeppelin/uniswap-hooks/src/base/BaseHook.sol";
import {BeforeSwapDelta, BeforeSwapDeltaLibrary} from "@openzeppelin/uniswap-hooks/lib/v4-core/src/types/BeforeSwapDelta.sol";

contract OneTimeSwap is BaseHook {
    bool public s_swapDone;

    error SwapAlreadyDone();
    event SwapDone();

    constructor(IPoolManager _poolManager) BaseHook(_poolManager) {
        s_swapDone = false;
    }

    function getHookPermissions()
        public
        pure
        override
        returns (Hooks.Permissions memory)
    {
        return
            Hooks.Permissions({
                beforeInitialize: false,
                afterInitialize: false,
                beforeAddLiquidity: false,
                afterAddLiquidity: false,
                beforeRemoveLiquidity: false,
                afterRemoveLiquidity: false,
                beforeSwap: true, // Enable the beforeSwap hook
                afterSwap: false,
                beforeDonate: false,
                afterDonate: false,
                beforeSwapReturnDelta: false,
                afterSwapReturnDelta: false,
                afterAddLiquidityReturnDelta: false,
                afterRemoveLiquidityReturnDelta: false
            });
    }

    function beforeSwap(
        address /*sender*/,
        PoolKey calldata /*key*/,
        IPoolManager.SwapParams calldata /*params*/,
        bytes calldata /*hookData*/
    )
        external
        override
        onlyPoolManager
        returns (bytes4, BeforeSwapDelta, uint24)
    {
        if (s_swapDone) {
            revert SwapAlreadyDone();
        }

        emit SwapDone();
        s_swapDone = true;
        return (
            BaseHook.beforeSwap.selector,
            BeforeSwapDeltaLibrary.ZERO_DELTA,
            0
        );
    }
}
