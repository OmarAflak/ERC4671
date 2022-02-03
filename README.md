---
eip: 4671
title: Non-Tradable Tokens
description: A standard interface for non-tradable tokens.
author: Omar Aflak (@omaraflak), Pol-Malo Le Bris, Marvin Martin (@MarvinMartin24)
discussions-to: https://ethereum-magicians.org/t/eip-4671-non-tradable-token/7976
status: Draft
type: Standards Track
category: ERC
created: 2022-01-13
requires: 165
---

# Non-Tradable Token Standard

<!-- AUTO-GENERATED-CONTENT:START (TOC) -->
- [Abstract](#abstract)
- [Motivation](#motivation)
- [Specification](#specification)
  - [NTT](#ntt)
    - [Extensions](#extensions)
  - [NTT Store](#ntt-store)
- [Rationale](#rationale)
  - [On-chain vs Off-chain](#on-chain-vs-off-chain)
- [Implementation](#implementation)
- [Copyright](#copyright)
<!-- AUTO-GENERATED-CONTENT:END -->

## Abstract

NTTs represent inherently personal possessions (material or immaterial), such as university diploma, online training certificates, government issued documents (national id, driving licence, visa, wedding, etc.), badges, labels, and so on.

As the name implies, NTTs are not made to be traded or transfered. They don't have monetary value. They are personally delivered to **you**, and they only serve as a **proof of possession**.

## Motivation

US, 2017, MIT published 111 diplomas on a blockchain. France, 2018, Carrefour multinational retail corporation used blockchain technology to certify the provenance of its chickens. South Korea, 2019, the state published 1 million driving licences on a blockchain-powered platform.

Each of them made their own smart contracts, with different implementations. We think diplomas, food labels, or driving licences are just a subset of a more general type of tokens: **non-tradable tokens**. Tokens that represent certificates or labels that were granted to you by some authority.

By providing a common interface for this type of tokens, we allow more applications to be developed and we position blockchain technology as a standard gateway for verification of personal possessions.

## Specification

### NTT

A single NTT contract, is seen as representing one type of badge by one authority. For instance, one NTT contract for PSN achievements, another for Ethereum EIP creators, and so on...

* An address might possess multiple tokens. Each token has a unique identifier: `tokenId`.
* An authority who delivers a certificate should be in position to invalidate it. Think of driving licences or weddings. However, it cannot delete your token.
* The most typical usage for third-parties will be to verify if a user has a valid token in a NTT contract.

<!-- AUTO-GENERATED-CONTENT:START (CODE:syntax=solidity&src=./contracts/IERC4671.sol) -->
<!-- The below code snippet is automatically added from ./contracts/IERC4671.sol -->
```solidity
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/introspection/IERC165.sol";

interface IERC4671 is IERC165 {
    /// Event emitted when a token `tokenId` is minted for `owner`
    event Minted(address owner, uint256 tokenId);

    /// Event emitted when token `tokenId` of `owner` is invalidated
    event Invalidated(address owner, uint256 tokenId);

    /// @notice Count all tokens assigned to an owner
    /// @param owner Address for whom to query the balance
    /// @return Number of tokens owned by `owner`
    function balanceOf(address owner) external view returns (uint256);

    /// @notice Get owner of a token
    /// @param tokenId Identifier of the token
    /// @return Address of the owner of `tokenId`
    function ownerOf(uint256 tokenId) external view returns (address);

    /// @notice Check if a token hasn't been invalidated
    /// @param tokenId Identifier of the token
    /// @return True if the token is valid, false otherwise
    function isValid(uint256 tokenId) external view returns (bool);

    /// @notice Check if an address owns a valid token in the contract
    /// @param owner Address for whom to check the ownership
    /// @return True if `owner` has a valid token, false otherwise
    function hasValid(address owner) external view returns (bool);
}
```
<!-- AUTO-GENERATED-CONTENT:END -->

#### Extensions

##### Metadata

An interface allowing to add metadata linked to each token, as in ERC721.

<!-- AUTO-GENERATED-CONTENT:START (CODE:syntax=solidity&src=./contracts/IERC4671Metadata.sol) -->
<!-- The below code snippet is automatically added from ./contracts/IERC4671Metadata.sol -->
```solidity
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IERC4671.sol";

interface IERC4671Metadata is IERC4671 {
    /// @return Descriptive name of the tokens in this contract
    function name() external view returns (string memory);

    /// @return An abbreviated name of the tokens in this contract
    function symbol() external view returns (string memory);

    /// @notice URI to query to get the token's metadata
    /// @param tokenId Identifier of the token
    /// @return URI for the token
    function tokenURI(uint256 tokenId) external view returns (string memory);
}
```
<!-- AUTO-GENERATED-CONTENT:END -->

##### Enumerable

An interface allowing to enumerate the tokens of an owner, as in ERC721.

<!-- AUTO-GENERATED-CONTENT:START (CODE:syntax=solidity&src=./contracts/IERC4671enumerable.sol) -->
<!-- The below code snippet is automatically added from ./contracts/IERC4671enumerable.sol -->
```solidity
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IERC4671.sol";

interface IERC4671Enumerable is IERC4671 {
    /// @return Total number of tokens emitted by the contract
    function total() external view returns (uint256);

    /// @notice Get the tokenId of a token using its position in the owner's list
    /// @param owner Address for whom to get the token
    /// @param index Index of the token
    /// @return tokenId of the token
    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
}
```
<!-- AUTO-GENERATED-CONTENT:END -->

##### Delegation

An interface allowing delegation rights of token minting.

<!-- AUTO-GENERATED-CONTENT:START (CODE:syntax=solidity&src=./contracts/IERC4671Delegate.sol) -->
<!-- The below code snippet is automatically added from ./contracts/IERC4671Delegate.sol -->
```solidity
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IERC4671.sol";

interface IERC4671Delegate is IERC4671 {
    /// @notice Grant one-time minting right to `operator` for `owner`
    /// An allowed operator can call the function to transfer rights.
    /// @param operator Address allowed to mint a token
    /// @param owner Address for whom `operator` is allowed to mint a token
    function delegate(address operator, address owner) external;

    /// @notice Grant one-time minting right to a list of `operators` for a corresponding list of `owners`
    /// An allowed operator can call the function to transfer rights.
    /// @param operators Addresses allowed to mint
    /// @param owners Addresses for whom `operators` are allowed to mint a token
    function delegateBatch(address[] memory operators, address[] memory owners) external;

    /// @notice Mint a token. Caller must have the right to mint for the owner.
    /// @param owner Address for whom the token is minted
    function mint(address owner) external;

    /// @notice Mint tokens to multiple addresses. Caller must have the right to mint for all owners.
    /// @param owners Addresses for whom the tokens are minted
    function mintBatch(address[] memory owners) external;

    /// @notice Get the issuer of a token
    /// @param tokenId Identifier of the token
    /// @return Address who minted `tokenId`
    function issuerOf(uint256 tokenId) external view returns (address);
}
```
<!-- AUTO-GENERATED-CONTENT:END -->

##### Consensus

An interface allowing minting/invalidation of tokens based on a consensus of a predefined set of addresses.

<!-- AUTO-GENERATED-CONTENT:START (CODE:syntax=solidity&src=./contracts/IERC4671Consensus.sol) -->
<!-- The below code snippet is automatically added from ./contracts/IERC4671Consensus.sol -->
```solidity
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IERC4671.sol";

interface IERC4671Consensus is IERC4671 {
    /// @notice Get voters addresses for this consensus contract
    /// @return Addresses of the voters
    function voters() external view returns (address[] memory);

    /// @notice Cast a vote to mint a token for a specific address
    /// @param owner Address for whom to mint the token
    function approveMint(address owner) external;

    /// @notice Cast a vote to invalidate a specific token
    /// @param tokenId Identifier of the token to invalidate
    function approveInvalidate(uint256 tokenId) external;
}
```
<!-- AUTO-GENERATED-CONTENT:END -->

### NTT Store

NTTs are meant to be fetched by third-parties, which is why there need to be a convienent way for users to expose some or all of their NTTs. We achieve this result using a store which must implement the following interface.

<!-- AUTO-GENERATED-CONTENT:START (CODE:syntax=solidity&src=./contracts/IERC4671Store.sol) -->
<!-- The below code snippet is automatically added from ./contracts/IERC4671Store.sol -->
```solidity
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/introspection/IERC165.sol";

interface IERC4671Store is IERC165 {
    // Event emitted when a NTT contract is added to the owner's records
    event Added(address owner, address ntt);

    // Event emitted when a NTT contract is removed from the owner's records
    event Removed(address owner, address ntt);

    /// @notice Add a NTT contract address to the caller's record
    /// @param ntt Address of the NTT contract to add
    function add(address ntt) external;

    /// @notice Remove a NTT contract from the caller's record
    /// @param ntt Address of the NTT contract to remove
    function remove(address ntt) external;

    /// @notice Get all the NTT contracts for a given owner
    /// @param owner Address for which to retrieve the NTT contracts
    function get(address owner) external view returns (address[] memory);
}
```
<!-- AUTO-GENERATED-CONTENT:END -->

## Rationale

### On-chain vs Off-chain

A decision was made to keep the data off-chain (via `tokenURI()`) for two main reasons: 
* Non-Tradable Tokens represent personal possessions. Therefore, there might be cases where the data should be encrypted. The standard should not outline decisions about encryption because there are just so many ways this could be done, and every possibility is specific to the use-case.
* Non-Tradable Tokens must stay generic. There could have been a possibility to make a `MetadataStore` holding the data of NTTs in an elegant way, unfortunately we would have needed a support for generics in solidity (or struct inheritance), which is not available today.

## Implementation

You can find implementations of the NTT standard at the following links.

* [https://github.com/OmarAflak/Non-Tradable-Token/tree/master/contracts](https://github.com/OmarAflak/Non-Tradable-Token/tree/master/contracts)


## Copyright

Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
