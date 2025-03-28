-include .env

install:
	@forge install OpenZeppelin/uniswap-hooks --no-commit && forge install Uniswap/v4-periphery --no-commit

deploy:
	@forge script script/DeployOneTimeSwap.s.sol:DeployOneTimeSwap --rpc-url $(SEPOLIA_RPC_URL) --account burner --sender 0xFB6a372F2F51a002b390D18693075157A459641F --broadcast --verify --etherscan-api-key ${ETHERSCAN_API_KEY} -vvvv