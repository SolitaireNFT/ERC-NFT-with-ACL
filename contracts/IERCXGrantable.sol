pragma solidity ^0.8.0;

/// @title ERC-X Non-Fungible Token permission Standard
/// @dev See https://eips.ethereum.org/EIPS/eip-X
///  Note: the ERC-165 identifier for this interface is 0x80ac58cd.
interface IERCXGrantable  /* is ERC721, ERC165 maybe ERC2615 */ {
    /// @dev This emits when ownership of any NFT changes by any mechanism.
    ///  This event emits when NFTs are created (`from` == 0) and destroyed
    ///  (`to` == 0). Exception: during contract creation, any number of NFTs
    ///  may be created and assigned without emitting Transfer. At the time of
    ///  any transfer, the approved address for that NFT (if any) is reset to none.
    event PermissionChange(address indexed _user, uint256 indexed _tokenId, uint256 permission, string reason);

    /// @notice Count all NFTs assigned to an owner
    /// @dev NFTs assigned to the zero address are considered invalid, and this
    ///  function throws for queries about the zero address.
    /// @param _owner An address for whom to query the balance
    /// @return The number of NFTs owned by `_owner`, possibly zero
    function access(address _user, uint256 _tokenId, uint256 permission) external view returns (bool);

    /// @notice Find the permission of an NFT to specific user
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param _tokenId The identifier for an NFT
    /// @return The permission of the user of the NFT
    function permission(address _user, uint256 _tokenId) external view returns (u256);

    /// @notice Transfers the ownership of an NFT from one address to another address
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the same permission granted address for this NFT. Throws if `_to` is the zero address.
    /// Throws if `_tokenId` is not a valid NFT. When transfer is complete, this function
    ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
    ///  `onERC721Received` on `_to` and throws if the return value is not
    ///  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
    /// @param _from The current permission owner of the NFT
    /// @param _to The new permission owner
    /// @param _tokenId The NFT to grant permission from.
    /// @param data Additional data with no specified format, sent in call to `_to`
    function grant(address _from, address _to, uint256 _tokenId, uint256 permission, string reason) external payable;

    /// @notice Transfers the ownership of an NFT from one address to another address
    /// @dev This works identically to the other function with an extra data parameter,
    ///  except this function just sets data to "".
    /// @param _from The current owner of the NFT
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
