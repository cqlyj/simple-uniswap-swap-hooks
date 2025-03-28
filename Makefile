-include .env

install:
	@forge install OpenZeppelin/uniswap-hooks --no-commit && forge install Uniswap/v4-periphery --no-commit