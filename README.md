# Simple Uniswap V4 Swap Hook

This implements a simple swap hook which allows a certain address to swap only once with the help of `beforeSwap` hook.

You can find more information about the `beforeSwap` hook in the [Uniswap V4 documentation](https://docs.uniswap.org/contracts/v4/guides/hooks/your-first-hook).

# Getting Started

## Requirements

- [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
  - You'll know you did it right if you can run `git --version` and you see a response like `git version x.x.x`
- [foundry](https://getfoundry.sh/)
  - You'll know you did it right if you can run `forge --version` and you see a response like `forge 0.3.0 (5a8bd89 2024-12-19T17:17:10.245193696Z)`

## Quickstart

```
git clone https://github.com/cqlyj/simple-uniswap-swap-hooks
cd simple-uniswap-swap-hooks
make
```

# Usage

1. Set up your environment variables and fill in the `.env` file with your own values.

```bash
cp .env.example .env
```

2. Deploy the `OneTimeSwap` contract:

```bash
make deploy
```

3. Create pool and add liquidity:

```bash
make create-pool-and-add-liquidity
```

Here we create a pool with 1 **Link** and 1 **DAI** on Sepolia testnet.

4. Swap:

```bash
make swap
```

This will swap 1 **Link** for 1 **DAI**. And if you tries to swap again, it will revert as below

```bash
    │   │   │   ├─ [10708] PoolManager::swap(PoolKey({ currency0: 0x779877A7B0D9E8603169DdbD7836e478b4624789, currency1: 0xFF34B3d4Aee8ddCd6F9AFFFB6Fe49bD371b8a357, fee: 3000, tickSpacing: 60, hooks: 0x332C041E120EF1B853F373EFD3b5AaB45B868080 }), SwapParams({ zeroForOne: true, amountSpecified: 1000000000000000000 [1e18], sqrtPriceLimitX96: 4295128740 [4.295e9] }), 0x)
    │   │   │   │   ├─ [2973] 0x332C041E120EF1B853F373EFD3b5AaB45B868080::beforeSwap(PoolSwapTest: [0x9B6b46e2c869aa39918Db7f52f5557FE577B6eEe], PoolKey({ currency0: 0x779877A7B0D9E8603169DdbD7836e478b4624789, currency1: 0xFF34B3d4Aee8ddCd6F9AFFFB6Fe49bD371b8a357, fee: 3000, tickSpacing: 60, hooks: 0x332C041E120EF1B853F373EFD3b5AaB45B868080 }), SwapParams({ zeroForOne: true, amountSpecified: 1000000000000000000 [1e18], sqrtPriceLimitX96: 4295128740 [4.295e9] }), 0x)
    │   │   │   │   │   └─ ← [Revert] SwapAlreadyDone()
```

# Test

You can run the tests with the following command:

```bash
forge test -vvvv
```

This will run the tests which shows the whole process above.

## Contact

Luo Yingjie - [luoyingjie0721@gmail.com](luoyingjie0721@gmail.com)
