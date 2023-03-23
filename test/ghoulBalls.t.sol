// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "../src/ghoulBalls.sol";


import {MockERC721} from "solmate/test/utils/mocks/MockERC721.sol";

contract ghoulBallsTest is Test {
    MockERC721 mockNFT;
    animatedGhoulBalls nft;
    
    function setUp() public {
        vm.warp(1656059716);
        mockNFT = new MockERC721("BasedGhouls", "BasedGhouls");
        nft = new animatedGhoulBalls();
        nft.updateGhoulAddr(address(mockNFT));
        mockNFT.mint(address(this), 1);
    }

    function testMinting() public {
        nft.mint_the_ball(1);
        assertEq(nft.ownerOf(1), address(this));
        assertEq(nft.balanceOf(address(this)), 1);
    }

    function testBadMinting() public {
        mockNFT.mint(address(this), 6665);

        vm.startPrank(address(1337));
        vm.expectRevert("not your ghoul.");
        nft.mint_the_ball(6665);
    }

    function testUri() public {
        nft.mint_the_ball(1);
        string memory uriOutput = nft.tokenPNG(1);
        vm.writeFile(string.concat('test/output/test_uri1.txt'), uriOutput);
    }
}
