---
eip: TBD
title: Non-Fungible Token with ACL (access control list)
description: This is a standard for separating ownership and rights of use on digital assets.
author: [Dong Shan](https://twitter.com/Necokeine), [Brian Zhou](https://twitter.com/brianzzz95)
discussions-to: https://ethereum-magicians.org/t/eip-proposal-non-fungible-token-with-acl/8401
status: Draft
type: Standards Track
category: ERC
created: 2022-02-22
requires: 165, 721
---

## Abstract
This is a standard for separating ownership and rights of use on digital assets. It proposes an extension to ERC721 for NFTs to be utilized while preserving ownership.

## Motivation
"Did I just buy a JPEG, or an NFT?"
NFT skeptics, and, frankly, many NFT owners often have this question. NFTs gained explosive popularity in 2021. OpenSea, one of the major NFT marketplaces, reported $3.4 billion trading volume in August 2021. This jaw-dropping record got topped in just a few months: OpenSea hit an all-time high trading volume of $5 billion in January 2022. With this meteoric rise in user base and appreciation, there comes a tremendous growth on the supply side - As of January 2022, it is estimated that, every week, there are 20,000 to 50,000 sales of NFT projects, each of which usually consists of thousands of NFT assets.
As the supply grows, NFT owners may want to grant different permissions to others like timed ownership(rental), derivative works (IP licensing), co-edit. For example, renting items in blockchain games, licensing and earning royalty from PFP derivative works, hiring builders to build properties on virtual lands.

## Specification

The key words “MUST”, “MUST NOT”, “REQUIRED”, “SHALL”, “SHALL NOT”, “SHOULD”, “SHOULD NOT”, “RECOMMENDED”, “MAY”, and “OPTIONAL” in this document are to be interpreted as described in RFC 2119.

```solidity
pragma solidity ^0.8.0;

/// @title ERC-X - Non-Fungible Token ACL Standard
/// @dev See https://eips.ethereum.org/EIPS/eip-X
/// Note: the ERC-165 identifier for this interface is 0xXXXXXXXX.
interface IERCXGrantable  /* is ERC721, ERC165 maybe ERC2615, ERC1155 */ {
    /// @dev This emits when ownership of any NFT changes by any mechanism.
    ///  This event emits when NFTs are created (`from` == 0) and destroyed
    ///  (`to` == 0). Exception: during contract creation, any number of NFTs
    ///  may be created and assigned without emitting Transfer. At the time of
    ///  any transfer, the approved address for that NFT (if any) is reset to none.
    event PermissionChange(address indexed _user, uint256 indexed _tokenId, uint256 permission, string reason);

    /// @notice Find the permission of an NFT to specific user
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param _tokenId The identifier for an NFT
    /// @return The permission of the user of the NFT
    ///      Empty permission should be 0.
    ///      Owner's permission should be max u256.
    function permission(address _user, uint256 _tokenId) external view returns (u256);

    /// @notice Grant the permission of an NFT from _from to the _to user.
    /// @dev Throws unless `msg.sender` is the NFT owner, an authorized
    ///  operator, or licensees who have the same permission.
    ///  _from must be msg.sender.
    ///  Throws if `_to` is the zero address.
    ///  Throws if `_tokenId` is not a valid NFT.
    ///  When transfer is complete, this function
    ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
    ///  `onERCXReceived` on `_to` and throws if the return value is not
    ///  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
    /// @param _from The current permission owner of the NFT or NFT owner.
    /// @param _to The new permission owner
    /// @param _tokenId The NFT to grant permission from.
    /// @param reason Additional human readable message.
    function grant(address _from, address _to, uint256 _tokenId, uint256 permission, string reason) external payable;

    /// @notice Revoke permission from _to, which granted by _from.
    /// @dev This function is optional when permission is unique,
    ///  throws unless msg.sender is NFT owner or
    ///  _from must be msg.sender
    /// @param _from The current  of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    /// token owner / the _from.
    function revoke(address _from, address _to, uint256 _tokenId) external payable;
}

interface ERC165 {
    /// @notice Query if a contract implements an interface
    /// @param interfaceID The interface identifier, as specified in ERC-165
    /// @dev Interface identification is specified in ERC-165. This function
    ///  uses less than 30,000 gas.
    /// @return `true` if the contract implements `interfaceID` and
    ///  `interfaceID` is not 0xffffffff, `false` otherwise
    function supportsInterface(bytes4 interfaceID) external view returns (bool);
}
```

## Rationale
### Multi-tenant access
We want to enable multiple users to access or say, use the NFT with overlaps in timeline. To achieve this, the owner or delegate of the owner should be able to give other users one or multiple permissions, without transferring the ownership.

### Minimum viable proposal
The permission list is encoded into a u256 integer. We aim to provide as much flexibility as possible for developers. In particular, we don’t limit or specify which party is able to give out, revoke permissoins.

### Proof of rights
By nature, the permission or say, “right” itself should be an NFT instead of FT in most cases. We speculate this will be a common practice since by doing this, “proof of rights” NFTs are circulated on the market which is similar to how contracts and financial products are circulated in real life. The developer is able to achieve this by simply minting an NFT for rights to the licensee in the “grant” function.

### Linux permission model use case figure

## Backwards Compatibility
As mentioned in the specifications section, this standard can be fully ERC721 compatible by adding an extension function set.
After modeling the permission as some additional NFT, it is also compatible with ERC2615.
Note that, the NFT owner is supposed to have the “root” permission. Keep in mind that giving out "ownership" as a special permission might conflict with the design of ERC721.

## Use Cases
- Uncollateralized rental of game items
- Collaborations on virtual lands
- PFP derivative works

## Reference Implementation
https://github.com/SolitaireNFT/ERCX_Example/tree/master/contracts

## Security Considerations
This EIP releases much flexibility to the Contract developer, and also may be very different under different use cases. To align all different developers and users, we may need a more specific standard.

## Copyright
Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
