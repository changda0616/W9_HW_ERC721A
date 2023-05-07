// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/ERC721AToken.sol";
import "ERC721A/IERC721A.sol";

contract ERC721ATokenTest is Test {
    ERC721AToken public tokenContract;
    address owner = makeAddr("owner");
    address user1 = makeAddr("user1");
    address user2 = makeAddr("user2");

    event Approval(
        address indexed _owner,
        address indexed _approved,
        uint256 indexed _tokenId
    );
    event ApprovalForAll(
        address indexed _owner,
        address indexed _operator,
        bool _approved
    );
    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 indexed _tokenId
    );

    function setUp() public {
        vm.startPrank(owner);
        tokenContract = new ERC721AToken();
        vm.stopPrank();
    }

    function testSetup() public {
        assertEq(tokenContract.name(), "BatchableToken");
        assertEq(tokenContract.symbol(), "BTK");
    }

    function testMint30() public {
        uint256 amount = 30;
        vm.startPrank(owner);
        tokenContract.mint(user1, amount);
        vm.stopPrank();

        assertEq(tokenContract.balanceOf(user1), amount);

        assertEq(tokenContract.totalSupply(), amount);
        assertEq(tokenContract.ownerOf(0), user1);
        assertEq(tokenContract.ownerOf(amount - 1), user1);
    }

    function testApprovaAll30() public {
        uint256 amount = 30;
        vm.startPrank(owner);

        tokenContract.mint(user1, amount);

        // approve
        changePrank(user1);
        vm.expectEmit(true, true, false, false);
        emit ApprovalForAll(user1, user2, true);
        tokenContract.setApprovalForAll(user2, true);

        // test approval
        assertEq(tokenContract.isApprovedForAll(user1, user2), true);

        changePrank(user2);

        // test transfer all
        for (uint i = 0; i < amount; i++) {
            vm.expectEmit(true, true, true, false);
            emit Transfer(user1, user2, i);
            tokenContract.transferFrom(user1, user2, i);

            assertEq(tokenContract.ownerOf(i), user2);
        }

        vm.stopPrank();

        assertEq(tokenContract.balanceOf(user2), amount);
    }

    function testTransfer30() public {
        uint256 amount = 30;
        vm.startPrank(owner);

        tokenContract.mint(user1, amount);

        // approve
        changePrank(user1);
        tokenContract.setApprovalForAll(user2, true);

        // test approval
        assertEq(tokenContract.isApprovedForAll(user1, user2), true);

        changePrank(user2);

        // test transfer all
        for (uint i = 0; i < amount; i++) {
            vm.expectEmit(true, true, true, false);
            emit Transfer(user1, user2, i);
            tokenContract.transferFrom(user1, user2, i);

            assertEq(tokenContract.ownerOf(i), user2);
        }

        vm.stopPrank();

        assertEq(tokenContract.balanceOf(user2), amount);
    }

    function testMint2() public {
        uint256 amount = 2;
        vm.startPrank(owner);
        tokenContract.mint(user1, amount);
        vm.stopPrank();

        assertEq(tokenContract.balanceOf(user1), amount);

        assertEq(tokenContract.totalSupply(), amount);
        assertEq(tokenContract.ownerOf(0), user1);
        assertEq(tokenContract.ownerOf(amount - 1), user1);
    }
    function testApprova2() public {
        uint256 amount = 2;
        vm.startPrank(owner);

        tokenContract.mint(user1, amount);

        // approve
        changePrank(user1);
        vm.expectEmit(true, true, false, false);
        emit ApprovalForAll(user1, user2, true);
        tokenContract.setApprovalForAll(user2, true);

        // test approval
        assertEq(tokenContract.isApprovedForAll(user1, user2), true);

        changePrank(user2);

        // test transfer all
        for (uint i = 0; i < amount; i++) {
            vm.expectEmit(true, true, true, false);
            emit Transfer(user1, user2, i);
            tokenContract.transferFrom(user1, user2, i);

            assertEq(tokenContract.ownerOf(i), user2);
        }

        vm.stopPrank();

        assertEq(tokenContract.balanceOf(user2), amount);
    }
    function testTransfer2() public {
        uint256 amount = 2;
        vm.startPrank(owner);

        tokenContract.mint(user1, amount);

        // approve
        changePrank(user1);
        tokenContract.setApprovalForAll(user2, true);

        // test approval
        assertEq(tokenContract.isApprovedForAll(user1, user2), true);

        changePrank(user2);

        // test transfer all
        for (uint i = 0; i < amount; i++) {
            vm.expectEmit(true, true, true, false);
            emit Transfer(user1, user2, i);
            tokenContract.transferFrom(user1, user2, i);

            assertEq(tokenContract.ownerOf(i), user2);
        }

        vm.stopPrank();

        assertEq(tokenContract.balanceOf(user2), amount);
    }
}

// [PASS] testSetup() (gas: 14642)

// [PASS] testMint2() (gas: 98032)
// [PASS] testMint30() (gas: 214181)
// [PASS] testApprova2() (gas: 192203)
// [PASS] testApprovaAll30() (gas: 1191954)
// [PASS] testTransfer2() (gas: 189766)
// [PASS] testTransfer30() (gas: 1189508)
// Test result: ok. 7 passed; 0 failed; finished in 1.62ms
// | src/ERC721AToken.sol:ERC721AToken contract |                 |        |        |        |         |
// |--------------------------------------------|-----------------|--------|--------|--------|---------|
// | Deployment Cost                            | Deployment Size |        |        |        |         |
// | 931777                                     | 4907            |        |        |        |         |
// | Function Name                              | min             | avg    | median | max    | # calls |
// | balanceOf                                  | 618             | 618    | 618    | 618    | 6       |
// | isApprovedForAll                           | 815             | 815    | 815    | 815    | 4       |
// | mint                                       | 75799           | 102861 | 102861 | 129923 | 6       |
// | name                                       | 3285            | 3285   | 3285   | 3285   | 1       |
// | ownerOf                                    | 823             | 1799   | 823    | 65029  | 68      |
// | setApprovalForAll                          | 24507           | 24507  | 24507  | 24507  | 4       |
// | symbol                                     | 3328            | 3328   | 3328   | 3328   | 1       |
// | totalSupply                                | 2410            | 2410   | 2410   | 2410   | 2       |
// | transferFrom                               | 8628            | 28817  | 28703  | 50603  | 64      |
