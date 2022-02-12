---
eip: 4671
title: Badge Standard
description: A standard interface for badges.
author: Omar Aflak (@omaraflak), Pol-Malo Le Bris, Marvin Martin (@MarvinMartin24)
discussions-to: https://ethereum-magicians.org/t/eip-4671-non-tradable-token/7976
status: Draft
type: Standards Track
category: ERC
created: 2022-01-13
requires: 165
---

## Abstract

Badges represent inherently personal possessions (material or immaterial), such as university diploma, online training certificates, government issued documents (national id, driving license, visa, wedding, etc.), labels, and so on.

Badges are not made to be traded or transferred, they are "soulbound". Badges don't have monetary value. They are personally delivered to **you**, and they only serve as a **proof of possession**.

Since badges are not tradable, the possession of a badge carries meaning in itself.

## Motivation

We have seen in the past smart contracts being used to deliver university diplomas or driving licenses, for food labeling or attendance to events, and much more. All of these implementations are different, but they have a common ground: they are **non-tradable**.

Blockchain has been used for too long as a means of speculation, and the badge standard wants to be part of the general effort aiming to provide usefulness through the blockchain.

By providing a common interface for badges, we allow more applications to be developed and we position blockchain technology as a standard gateway for verification of personal possessions.

## Specification

### Badge

A badge contract is seen as representing one type of certificate by one authority. For instance, one badge contract for the French national id, another for Ethereum EIP creators, and so on...

* An address might possess multiple badges. Each badge has a unique identifier: `badgeId`.
* An authority who delivers a certificate should be in position to invalidate it. Think of driving licenses or weddings. However, it cannot delete your badge, i.e. the record will show that you once owned a badge.
* The most typical usage for third-parties will be to verify if a user has a valid badge in a given contract.

<!-- AUTO-GENERATED-CONTENT:START (CODE:syntax=solidity&src=./contracts/IERC4671.sol) -->
<!-- The below code snippet is automatically added from ./contracts/IERC4671.sol -->
```solidity
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/introspection/IERC165.sol";

interface IERC4671 is IERC165 {
    /// Event emitted when a badge `badgeId` is minted for `owner`
    event Minted(address owner, uint256 badgeId);

    /// Event emitted when badge `badgeId` of `owner` is invalidated
    event Invalidated(address owner, uint256 badgeId);

    /// @notice Count all badges assigned to an owner
    /// @param owner Address for whom to query the balance
    /// @return Number of badges owned by `owner`
    function balanceOf(address owner) external view returns (uint256);

    /// @notice Get owner of a badge
    /// @param badgeId Identifier of the badge
    /// @return Address of the owner of `badgeId`
    function ownerOf(uint256 badgeId) external view returns (address);

    /// @notice Check if a badge hasn't been invalidated
    /// @param badgeId Identifier of the badge
    /// @return True if the badge is valid, false otherwise
    function isValid(uint256 badgeId) external view returns (bool);

    /// @notice Check if an address owns a valid badge in the contract
    /// @param owner Address for whom to check the ownership
    /// @return True if `owner` has a valid badge, false otherwise
    function hasValid(address owner) external view returns (bool);
}
```
<!-- AUTO-GENERATED-CONTENT:END -->

#### Extensions

##### Metadata

An interface allowing to add metadata linked to each badge, as in ERC721.

<!-- AUTO-GENERATED-CONTENT:START (CODE:syntax=solidity&src=./contracts/IERC4671Metadata.sol) -->
<!-- The below code snippet is automatically added from ./contracts/IERC4671Metadata.sol -->
```solidity
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IERC4671.sol";

interface IERC4671Metadata is IERC4671 {
    /// @return Descriptive name of the badges in this contract
    function name() external view returns (string memory);

    /// @return An abbreviated name of the badges in this contract
    function symbol() external view returns (string memory);

    /// @notice URI to query to get the badge's metadata
    /// @param badgeId Identifier of the badge
    /// @return URI for the badge
    function badgeURI(uint256 badgeId) external view returns (string memory);
}
```
<!-- AUTO-GENERATED-CONTENT:END -->

##### Enumerable

An interface allowing to enumerate the badges of an owner, as in ERC721.

<!-- AUTO-GENERATED-CONTENT:START (CODE:syntax=solidity&src=./contracts/IERC4671enumerable.sol) -->
<!-- The below code snippet is automatically added from ./contracts/IERC4671enumerable.sol -->
```solidity
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IERC4671.sol";

interface IERC4671Enumerable is IERC4671 {
    /// @return Total number of badges emitted by the contract
    function total() external view returns (uint256);

    /// @notice Get the badgeId of a badge using its position in the owner's list
    /// @param owner Address for whom to get the badge
    /// @param index Index of the badge
    /// @return badgeId of the badge
    function badgeOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
}
```
<!-- AUTO-GENERATED-CONTENT:END -->

##### Delegation

An interface allowing delegation rights of badge minting.

<!-- AUTO-GENERATED-CONTENT:START (CODE:syntax=solidity&src=./contracts/IERC4671Delegate.sol) -->
<!-- The below code snippet is automatically added from ./contracts/IERC4671Delegate.sol -->
```solidity
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IERC4671.sol";

interface IERC4671Delegate is IERC4671 {
    /// @notice Grant one-time minting right to `operator` for `owner`
    /// An allowed operator can call the function to transfer rights.
    /// @param operator Address allowed to mint a badge
    /// @param owner Address for whom `operator` is allowed to mint a badge
    function delegate(address operator, address owner) external;

    /// @notice Grant one-time minting right to a list of `operators` for a corresponding list of `owners`
    /// An allowed operator can call the function to transfer rights.
    /// @param operators Addresses allowed to mint
    /// @param owners Addresses for whom `operators` are allowed to mint a badge
    function delegateBatch(address[] memory operators, address[] memory owners) external;

    /// @notice Mint a badge. Caller must have the right to mint for the owner.
    /// @param owner Address for whom the badge is minted
    function mint(address owner) external;

    /// @notice Mint badges to multiple addresses. Caller must have the right to mint for all owners.
    /// @param owners Addresses for whom the badges are minted
    function mintBatch(address[] memory owners) external;

    /// @notice Get the issuer of a badge
    /// @param badgeId Identifier of the badge
    /// @return Address who minted `badgeId`
    function issuerOf(uint256 badgeId) external view returns (address);
}
```
<!-- AUTO-GENERATED-CONTENT:END -->

##### Consensus

An interface allowing minting/invalidation of badges based on a consensus of a predefined set of addresses.

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

    /// @notice Cast a vote to mint a badge for a specific address
    /// @param owner Address for whom to mint the badge
    function approveMint(address owner) external;

    /// @notice Cast a vote to invalidate a specific badge
    /// @param badgeId Identifier of the badge to invalidate
    function approveInvalidate(uint256 badgeId) external;
}
```
<!-- AUTO-GENERATED-CONTENT:END -->

### Badge Store

Badges are meant to be fetched by third-parties, which is why there needs to be a convenient way for users to expose some or all of their badges. We achieve this result using a store which must implement the following interface.

<!-- AUTO-GENERATED-CONTENT:START (CODE:syntax=solidity&src=./contracts/IERC4671Store.sol) -->
<!-- The below code snippet is automatically added from ./contracts/IERC4671Store.sol -->
```solidity
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/introspection/IERC165.sol";

interface IERC4671Store is IERC165 {
    // Event emitted when a IERC4671Enumerable contract is added to the owner's records
    event Added(address owner, address badge);

    // Event emitted when a IERC4671Enumerable contract is removed from the owner's records
    event Removed(address owner, address badge);

    /// @notice Add a IERC4671Enumerable contract address to the caller's record
    /// @param badge Address of the IERC4671Enumerable contract to add
    function add(address badge) external;

    /// @notice Remove a IERC4671Enumerable contract from the caller's record
    /// @param badge Address of the IERC4671Enumerable contract to remove
    function remove(address badge) external;

    /// @notice Get all the IERC4671Enumerable contracts for a given owner
    /// @param owner Address for which to retrieve the IERC4671Enumerable contracts
    function get(address owner) external view returns (address[] memory);
}
```
<!-- AUTO-GENERATED-CONTENT:END -->

## Rationale

### On-chain vs Off-chain

A decision was made to keep the data off-chain (via `badgeURI()`) for two main reasons: 
* Badges represent personal possessions. Therefore, there might be cases where the data should be encrypted. The standard should not outline decisions about encryption because there are just so many ways this could be done, and every possibility is specific to the use-case.
* Badges must stay generic. There could have been a possibility to make a `MetadataStore` holding the data of badges in an elegant way, unfortunately we would have needed a support for generics in solidity (or struct inheritance), which is not available today.

## Reference Implementation

You can find implementations of the badge standard at the following links.

* [https://github.com/OmarAflak/ERC4671/tree/master/contracts](https://github.com/OmarAflak/ERC4671/tree/master/contracts)

## Security Considerations

One security aspect is related to the `badgeURI` method which returns the metadata linked to a badge. Since the standard represents inherently personal possessions, users might want to encrypt the data in some cases e.g. national id cards. Moreover, it is the responsibility of the contract creator to make sure the URI returned by this method is available at all times.

The standard does not define any way to transfer a badge from one wallet to another. Therefore, users must be very cautious with the wallet they use to receive these badges. If a wallet is lost, the only way to get the badges back is for the issuing authority to deliver the badges again, akin real life.

## Copyright

Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).