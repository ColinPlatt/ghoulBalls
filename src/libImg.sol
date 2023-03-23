// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.17;

import './png.sol';

library libImg {

    struct IMAGE {
        uint256 width;
        uint256 height;
        png.FRAME[] frames;
    }

    function toIndex(int256 _x, int256 _y, uint256 _width) internal pure returns (uint256 index){
        unchecked{
            index = uint256(_y) * (_width +1) + uint256(_x) + 1;
        }
        
    }

    function assignMidPoint(uint256 seed, uint256 width, uint256 height) internal pure returns (int256 x, int256 y) {

        x = int256(
                (
                    ((seed >> 2*8) % width) +
                    (width / 2)
                ) /2
            );

        y = int256(
                (
                    ((seed) % height) +
                    (height / 2)

                ) /2
            );


    }

    function rasterFilledCircle(png.FRAME memory img, uint256 width, int256 xMid, int256 yMid, int256 r, bytes1 idxColour) internal pure returns (png.FRAME memory) {

        int256 xSym;
        int256 ySym;
        int256 x = 0;
        int256 y = int(r);

        bytes memory pixels = new bytes(width * (width+1));

        unchecked {
            for (x = xMid - r ; x <= xMid; x++) {
                for (y = yMid - r ; y <= yMid; y++) {
                    if ((x - xMid)*(x - xMid) + (y - yMid)*(y - yMid) <= r*r) 
                    {
                        xSym = xMid - (x - xMid);
                        ySym = yMid - (y - yMid);
                        // (x, y), (x, ySym), (xSym , y), (xSym, ySym) are in the circle
                        if (x >= 0 && y >= 0) {
                            pixels[toIndex(x, y, width)] = idxColour;
                        }
                        if (x >= 0 && ySym >= 0) {
                            pixels[toIndex(x, ySym, width)] = idxColour;
                        }
                        if (xSym >= 0 && y >= 0) {
                            pixels[toIndex(xSym, y, width)] = idxColour;
                        }
                        if (xSym >= 0 && ySym >= 0) {
                            pixels[toIndex(xSym, ySym, width)] = idxColour;
                        }
                    }
                }
            }
        }
        img.frame = pixels;

        return img;
    }

    function drawFrame(
        uint256 frameNum,
        uint256 width, 
        uint256 height, 
        int256[] memory xMid, 
        int256[] memory yMid
    ) internal view returns (png.FRAME memory) {
        require(xMid.length == yMid.length, "unbalanced");
        png.FRAME memory tempFrame;
        
        for (uint8 j = 0; j<xMid.length; j++) {                    
            tempFrame = rasterFilledCircle(
                tempFrame,
                width,
                (xMid[j] > int256(height/2))? xMid[j]-int256(frameNum * 4) : xMid[j]+int256(frameNum * 4),
                (yMid[j] > int256(width/2))? yMid[j]-int256(frameNum * 4) : yMid[j]+int256(frameNum * 4),
                int256(15), 
                bytes1(j+1)
            );
        }

        return tempFrame;

    }

    function drawImage(IMAGE memory img, uint256 circleCount) internal view returns (png.FRAME[] memory){
    
        unchecked {
            int256[] memory xMid = new int256[](circleCount);
            int256[] memory yMid = new int256[](circleCount);

            for (uint8 i = 0; i<circleCount; i++) {
                uint256 randoSeed = uint256(keccak256(abi.encodePacked(block.timestamp, i)));
                (xMid[i], yMid[i]) = assignMidPoint(randoSeed, img.width, img.height);
            }

            for(uint256 frameNum = 0; frameNum < 12; ++frameNum) {
                img.frames[frameNum] = drawFrame(
                    frameNum,
                    img.width, 
                    img.height, 
                    yMid,
                    yMid
                );
            }
        }
        
        return img.frames;

    }

}