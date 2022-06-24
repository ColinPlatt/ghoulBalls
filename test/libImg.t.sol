// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import {libImg} from "../src/libImg.sol";

contract imgTest is Test {

    function testDraw() public {

        vm.warp(1656059716);

        libImg.IMAGE memory imgPixels = libImg.IMAGE(
            64,
            64,
            new bytes(64*65)
        );
        
        emit log_bytes(libImg.drawImage(imgPixels, uint256(2)));

    }


}