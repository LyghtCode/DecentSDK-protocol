// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8;

import {ERC20} from 'solmate/src/tokens/ERC20.sol';
import '../splits/interfaces/ISplitMain.sol';
import "@openzeppelin/contracts/access/Ownable.sol";

import "hardhat/console.sol";

abstract contract Splits is Ownable {
  function _getSplitMain() internal virtual returns(address);
  function _getSplitWallet() internal virtual returns(address);
  function _setSplitWallet(address _splitWallet) internal virtual;

  function createSplit (
    address[] calldata accounts,
    uint32[] calldata percentAllocations,
    uint32 distributorFee
  ) public virtual onlyOwner {
    require(_getSplitWallet() == address(0), "Split already created");
    bytes memory payload = abi.encodeWithSignature(
      "createSplit(address[],uint32[],uint32,address)",
      accounts,
      percentAllocations,
      distributorFee,
      address(this)
    );
    (bool success, bytes memory returnData) = _getSplitMain().call(payload);
    require(success, "Could not create split");
    (address splitAddress) = abi.decode(returnData, (address));
    _setSplitWallet(splitAddress);
  }

  function distributeETH(
    address[] calldata accounts,
    uint32[] calldata percentAllocations,
    uint32 distributorFee,
    address distributorAddress
  ) public virtual requireSplit {
    _transferETHToSplit();
    bytes memory payload = abi.encodeWithSignature(
      "distributeETH(address,address[],uint32[],uint32,address)",
      _getSplitWallet(),
      accounts,
      percentAllocations,
      distributorFee,
      distributorAddress
    );
    (bool success, ) = _getSplitMain().call(payload);
    require(success);
  }

  function distributeERC20(
    ERC20 token,
    address[] calldata accounts,
    uint32[] calldata percentAllocations,
    uint32 distributorFee,
    address distributorAddress
  ) public virtual requireSplit {
    _transferERC20ToSplit(token);
    bytes memory payload = abi.encodeWithSignature(
      "distributeERC20(address,address,address[],uint32[],uint32,address)",
      _getSplitWallet(),
      token,
      accounts,
      percentAllocations,
      distributorFee,
      distributorAddress
    );
    (bool success, ) = _getSplitMain().call(payload);
    require(success);
  }

  function distributeAndWithdraw(
    address account,
    uint256 withdrawETH,
    ERC20[] memory tokens,
    address[] calldata accounts,
    uint32[] calldata percentAllocations,
    uint32 distributorFee,
    address distributorAddress
  ) public virtual requireSplit {
    if (withdrawETH != 0) {
      distributeETH(
        accounts,
        percentAllocations,
        distributorFee,
        distributorAddress
      );
    }

    for (uint256 i = 0; i < tokens.length; ++i) {
      distributeERC20(
        tokens[i],
        accounts,
        percentAllocations,
        distributorFee,
        distributorAddress
      );
    }

    _withdraw(account, withdrawETH, tokens);
  }

  function transferToSplit(
    uint256 transferETH,
    ERC20[] memory tokens
  ) public virtual requireSplit {
    if (transferETH != 0) {
      _transferETHToSplit();
    }

    for (uint256 i = 0; i < tokens.length; ++i) {
      _transferERC20ToSplit(tokens[i]);
    }
  }

  function _transferETHToSplit() internal virtual {
    (bool success, ) = _getSplitWallet().call{ value: address(this).balance }("");
    require(success, "Could not transfer ETH to split");
  }

  function _transferERC20ToSplit(ERC20 token) internal virtual {
    uint256 balance = token.balanceOf(address(this));
    token.transfer(_getSplitWallet(), balance);
  }

  function _withdraw (
    address account,
    uint256 withdrawETH,
    ERC20[] memory tokens
  ) internal virtual {
    bytes memory payload = abi.encodeWithSignature(
      "withdraw(address,uint256,address[])",
      account,
      withdrawETH,
      tokens
    );
    (bool success, ) = _getSplitMain().call(payload);
    require(success, "Could not withdraw from split");
  }

  modifier requireSplit() {
    require(_getSplitWallet() != address(0), "Split not created yet");
    _;
  }
}
