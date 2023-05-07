// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/EnumerableToken.sol";

contract ERC721EnumerableTest is Test {
    EnumerableToken public enumerableToken;
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
        enumerableToken = new EnumerableToken();
        vm.stopPrank();
    }

    function testSetup() public {
        assertEq(enumerableToken.name(), "EnumerableToken");
        assertEq(enumerableToken.symbol(), "ETK");
    }

    function testMint2() public {
        vm.startPrank(owner);
        enumerableToken.mint(user1);
        enumerableToken.mint(user1);
        vm.stopPrank();

        assertEq(enumerableToken.balanceOf(user1), 2);
        assertEq(enumerableToken.tokenOfOwnerByIndex(user1, 1), 1);
        assertEq(enumerableToken.totalSupply(), 2);
        assertEq(enumerableToken.tokenByIndex(1), 1);
    }

    function testApproveThenTransfer() public {
        vm.startPrank(owner);
        enumerableToken.mint(user1);
        enumerableToken.mint(user1);
        changePrank(user2);
        uint256 id = enumerableToken.tokenOfOwnerByIndex(user1, 0);

        // check transfer before apporving
        vm.expectRevert("ERC721: caller is not token owner or approved");
        enumerableToken.transferFrom(user1, user2, id);

        // check approve with wrong address
        vm.expectRevert(
            "ERC721: approve caller is not token owner or approved for all"
        );
        enumerableToken.approve(user2, id);

        // approve
        changePrank(user1);
        vm.expectEmit(true, true, true, false);
        emit Approval(user1, user2, id);
        enumerableToken.approve(user2, id);

        // test approval
        assertEq(enumerableToken.getApproved(id), user2);

        // transfer
        changePrank(user2);
        vm.expectEmit(true, true, true, false);
        emit Transfer(user1, user2, id);
        enumerableToken.transferFrom(user1, user2, id);
        vm.stopPrank();

        // test transfer
        assertEq(enumerableToken.ownerOf(id), user2);
        assertEq(enumerableToken.balanceOf(user2), 1);
    }

    function testApprovalForAll() public {
        vm.startPrank(owner);
        enumerableToken.mint(user1);
        enumerableToken.mint(user1);
        changePrank(user2);

        // check approve for all with wrong address
        vm.expectRevert("ERC721: approve to caller");
        enumerableToken.setApprovalForAll(user2, true);

        // approve
        changePrank(user1);
        vm.expectEmit(true, true, false, false);
        emit ApprovalForAll(user1, user2, true);
        enumerableToken.setApprovalForAll(user2, true);

        // test approval
        assertEq(enumerableToken.isApprovedForAll(user1, user2), true);

        changePrank(user2);
        uint256 amount = enumerableToken.balanceOf(user1);
        // test transfer all
        for (uint i = 0; i < amount; i++) {
            uint256 id = enumerableToken.tokenOfOwnerByIndex(user1, 0);
            vm.expectEmit(true, true, true, false);
            emit Transfer(user1, user2, id);
            enumerableToken.transferFrom(user1, user2, id);

            assertEq(enumerableToken.ownerOf(id), user2);
        }

        vm.stopPrank();

        assertEq(enumerableToken.balanceOf(user2), 2);
    }

    function testMint30() public {
        uint256 amount = 30;
        vm.startPrank(owner);
        for (uint i = 0; i < amount; i++) {
            enumerableToken.mint(user1);
        }
        vm.stopPrank();
        assertEq(enumerableToken.balanceOf(user1), amount);
        assertEq(enumerableToken.totalSupply(), amount);
        assertEq(enumerableToken.tokenByIndex(amount - 1), amount - 1);
    }

    function testApproveAll2() public {
        uint256 amount = 2;
        vm.startPrank(owner);
        for (uint i = 0; i < amount; i++) {
            enumerableToken.mint(user1);
        }
        changePrank(user1);
        vm.expectEmit(true, true, false, false);
        emit ApprovalForAll(user1, user2, true);
        enumerableToken.setApprovalForAll(user2, true);
        assertEq(enumerableToken.isApprovedForAll(user1, user2), true);
    }
    
    function testApproveAll30() public {
        uint256 amount = 30;
        vm.startPrank(owner);
        for (uint i = 0; i < amount; i++) {
            enumerableToken.mint(user1);
        }
        changePrank(user1);
        vm.expectEmit(true, true, false, false);
        emit ApprovalForAll(user1, user2, true);
        enumerableToken.setApprovalForAll(user2, true);
        assertEq(enumerableToken.isApprovedForAll(user1, user2), true);
    }

    function testTransfer2() public {
        uint256 amount = 2;
        vm.startPrank(owner);
        for (uint i = 0; i < amount; i++) {
            enumerableToken.mint(user1);
        }

        changePrank(user1);
        enumerableToken.setApprovalForAll(user2, true);
        // test transfer all
        for (uint i = 0; i < amount; i++) {
            uint256 id = enumerableToken.tokenOfOwnerByIndex(user1, 0);
            vm.expectEmit(true, true, true, false);
            emit Transfer(user1, user2, id);
            enumerableToken.transferFrom(user1, user2, id);

            assertEq(enumerableToken.ownerOf(id), user2);
        }

        assertEq(enumerableToken.isApprovedForAll(user1, user2), true);
    }
    function testTransfer30() public {
        uint256 amount = 30;
        vm.startPrank(owner);
        for (uint i = 0; i < amount; i++) {
            enumerableToken.mint(user1);
        }

        changePrank(user1);
        enumerableToken.setApprovalForAll(user2, true);
        // test transfer all
        for (uint i = 0; i < amount; i++) {
            uint256 id = enumerableToken.tokenOfOwnerByIndex(user1, 0);
            vm.expectEmit(true, true, true, false);
            emit Transfer(user1, user2, id);
            enumerableToken.transferFrom(user1, user2, id);

            assertEq(enumerableToken.ownerOf(id), user2);
        }

        assertEq(enumerableToken.isApprovedForAll(user1, user2), true);
    }
}

// [PASS] testSetup() (gas: 14664)
// [PASS] testApprovalForAll() (gas: 310766)
// [PASS] testApproveThenTransfer() (gas: 282815)

// [PASS] testMint2() (gas: 240181)
// [PASS] testMint30() (gas: 3495420)
// [PASS] testApproveAll2() (gas: 267204)
// [PASS] testApproveAll30() (gas: 3523610)
// [PASS] testTransfer2() (gas: 301761)
// [PASS] testTransfer30() (gas: 4196087)

// | src/EnumerableToken.sol:EnumerableToken contract |                 |        |        |        |         |
// |--------------------------------------------------|-----------------|--------|--------|--------|---------|
// | Deployment Cost                                  | Deployment Size |        |        |        |         |
// | 1386289                                          | 7198            |        |        |        |         |
// | Function Name                                    | min             | avg    | median | max    | # calls |
// | approve                                          | 3216            | 14215  | 14215  | 25214  | 2       |
// | balanceOf                                        | 634             | 634    | 634    | 634    | 5       |
// | getApproved                                      | 792             | 792    | 792    | 792    | 1       |
// | isApprovedForAll                                 | 815             | 815    | 815    | 815    | 3       |
// | mint                                             | 106215          | 115033 | 115615 | 115615 | 97      |
// | name                                             | 3285            | 3285   | 3285   | 3285   | 1       |
// | ownerOf                                          | 624             | 624    | 624    | 624    | 33      |
// | setApprovalForAll                                | 573             | 18597  | 24605  | 24605  | 4       |
// | symbol                                           | 3350            | 3350   | 3350   | 3350   | 1       |
// | tokenByIndex                                     | 804             | 804    | 804    | 804    | 2       |
// | tokenOfOwnerByIndex                              | 975             | 975    | 975    | 975    | 34      |
// | totalSupply                                      | 393             | 393    | 393    | 393    | 2       |
// | transferFrom                                     | 5759            | 40017  | 40907  | 43124  | 34      |