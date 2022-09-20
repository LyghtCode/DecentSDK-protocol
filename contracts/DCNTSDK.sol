// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
 ______   _______  _______  _______  _       _________
(  __  \ (  ____ \(  ____ \(  ____ \( (    /|\__   __/
| (  \  )| (    \/| (    \/| (    \/|  \  ( |   ) (
| |   ) || (__    | |      | (__    |   \ | |   | |
| |   | ||  __)   | |      |  __)   | (\ \) |   | |
| |   ) || (      | |      | (      | | \   |   | |
| (__/  )| (____/\| (____/\| (____/\| )  \  |   | |
(______/ (_______/(_______/(_______/|/    )_)   )_(

*/


/// ============ Imports ============

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";
import "./interfaces/IDCNTRegistry.sol";

contract DCNTSDK is Ownable {

  /// ============ Immutable storage ============

  /// ============ Mutable storage ============

  /// @notice implementation addresses for base contracts
  address public DCNT721AImplementation;
  address public DCNT4907AImplementation;
  address public DCNTCrescendoImplementation;
  address public DCNTVaultImplementation;
  address public DCNTStakingImplementation;

  /// @notice address of the associated registry
  address public contractRegistry;

  /// @notice addresses for splits contract
  address public SplitMain;

  /// ============ Events ============

  /// @notice Emitted after successfully deploying a contract
  event DeployDCNT721A(address DCNT721A);
  event DeployDCNT4907A(address DCNT4907A);
  event DeployDCNTCrescendo(address DCNTCrescendo);
  event DeployDCNTVault(address DCNTVault);
  event DeployDCNTStaking(address DCNTStaking);

  /// ============ Constructor ============

  /// @notice Creates a new DecentSDK instance
  constructor(
    address _DCNT721AImplementation,
    address _DCNT4907AImplementation,
    address _DCNTCrescendoImplementation,
    address _DCNTVaultImplementation,
    address _DCNTStakingImplementation,
    address _contractRegistry,
    address _SplitMain
  ) {
    DCNT721AImplementation = _DCNT721AImplementation;
    DCNT4907AImplementation = _DCNT4907AImplementation;
    DCNTCrescendoImplementation = _DCNTCrescendoImplementation;
    DCNTVaultImplementation = _DCNTVaultImplementation;
    DCNTStakingImplementation = _DCNTStakingImplementation;
    contractRegistry = _contractRegistry;
    SplitMain = _SplitMain;
  }

  /// ============ Functions ============

  // deploy and initialize an erc721a clone
  function deployDCNT721A(
    string memory _name,
    string memory _symbol,
    uint256 _maxTokens,
    uint256 _tokenPrice,
    uint256 _maxTokenPurchase
  ) external returns (address clone) {
    clone = Clones.clone(DCNT721AImplementation);
    (bool success, ) = clone.call(
      abi.encodeWithSignature(
        "initialize(address,string,string,uint256,uint256,uint256,address)",
        msg.sender,
        _name,
        _symbol,
        _maxTokens,
        _tokenPrice,
        _maxTokenPurchase,
        SplitMain
      )
    );
    require(success);
    IDCNTRegistry(contractRegistry).register(msg.sender, clone, 'DCNT721A');
    emit DeployDCNT721A(clone);
  }

  // deploy and initialize an erc4907a clone
  function deployDCNT4907A(
    string memory _name,
    string memory _symbol,
    uint256 _maxTokens,
    uint256 _tokenPrice,
    uint256 _maxTokenPurchase
  ) external returns (address clone) {
    clone = Clones.clone(DCNT4907AImplementation);
    (bool success, ) = clone.call(
      abi.encodeWithSignature(
        "initialize(address,string,string,uint256,uint256,uint256,address)",
        msg.sender,
        _name,
        _symbol,
        _maxTokens,
        _tokenPrice,
        _maxTokenPurchase,
        SplitMain
      )
    );
    require(success);
    IDCNTRegistry(contractRegistry).register(msg.sender, clone, 'DCNT4907A');
    emit DeployDCNT4907A(clone);
  }

  // deploy and initialize a Crescendo clone
  function deployDCNTCrescendo(
    string memory _name,
    string memory _symbol,
    string memory _uri,
    uint256 _initialPrice,
    uint256 _step1,
    uint256 _step2,
    uint256 _hitch,
    uint256 _trNum,
    uint256 _trDenom
  ) external returns (address clone) {
    clone = Clones.clone(DCNTCrescendoImplementation);
    (bool success, ) = clone.call(
      abi.encodeWithSignature(
        "initialize(address,string,string,string,uint256,uint256,uint256,uint256,uint256,uint256,address)",
        msg.sender,
        _name,
        _symbol,
        _uri,
        _initialPrice,
        _step1,
        _step2,
        _hitch,
        _trNum,
        _trDenom,
        SplitMain
      )
    );
    require(success);
    IDCNTRegistry(contractRegistry).register(msg.sender, clone, 'DCNTCrescendo');
    emit DeployDCNTCrescendo(clone);
  }

  // deploy and initialize a vault wrapper clone
  function deployDCNTVault(
    address _vaultDistributionTokenAddress,
    address _nftVaultKeyAddress,
    uint256 _nftTotalSupply,
    uint256 _unlockDate
  ) external returns (address clone) {
    clone = Clones.clone(DCNTVaultImplementation);
    (bool success, ) = clone.call(
      abi.encodeWithSignature("initialize(address,address,address,uint256,uint256)",
        msg.sender,
        _vaultDistributionTokenAddress,
        _nftVaultKeyAddress,
        _nftTotalSupply,
        _unlockDate
      )
    );
    require(success);
    IDCNTRegistry(contractRegistry).register(msg.sender, clone, 'DCNTVault');
    emit DeployDCNTVault(clone);
  }

  // deploy and initialize a vault wrapper clone
  function deployDCNTStaking(
    address _nft,
    address _token,
    uint256 _vaultDuration,
    uint256 _totalSupply
  ) external returns (address clone) {
    clone = Clones.clone(DCNTStakingImplementation);
    (bool success, ) = clone.call(
      abi.encodeWithSignature("initialize(address,address,address,uint256,uint256)",
        msg.sender,
        _nft,
        _token,
        _vaultDuration,
        _totalSupply
      )
    );
    require(success);
    IDCNTRegistry(contractRegistry).register(msg.sender, clone, 'DCNTStaking');
    emit DeployDCNTStaking(clone);
  }
}
