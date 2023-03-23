// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "src/animatedGhoulBalls.sol";

contract animatedGhoulBallsScript is Script {
    uint256 deployerPrivateKey = vm.envUint("PK");

    animatedGhoulBalls nft;

    function setUp() public {}

    function run() public {
        vm.startBroadcast(deployerPrivateKey);

            nft = new animatedGhoulBalls();

        vm.stopBroadcast();
    }
}


//forge script script/animatedGhoulBalls.s.sol:animatedGhoulBallsScript --rpc-url $RPC_URL --with-gas-price 20000000000  --broadcast --chain-id 1 --slow --verify --verifier etherscan -vvvv