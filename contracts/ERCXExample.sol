pragma solidity ^0.4.0;

import "./IERCXGrantable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract ERCXExample is ERC721, IERCXGrantable {
    // TokenId -> permissionOwner -> permission level
    mapping(uint256 => mapping(address => uint256)) private _permissionMap;
    /**
     * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
        return
        interfaceId == type(IERC721).interfaceId ||
        interfaceId == type(IERC721Metadata).interfaceId ||
        super.supportsInterface(interfaceId);
    }

    function access(address _user, uint256 _tokenId, uint256 permission) external view returns (bool) {
        address owner = ERC721.ownerOf(_tokenId);
        if (_user == owner) {
            return true;
        }
        return (_permissionMap[_tokenId][_user] & permission) == permission;
    }

    function permission(address _user, uint256 _tokenId) external view returns (u256) {
        return _permissionMap[_tokenId][_user];
    }

    function grant(address _from, address _to, uint256 _tokenId, uint256 permission, string reason) external payable override {
        address owner = ERC721.ownerOf(_tokenId);
        require(to != owner, "ERCX: grant permission to current owner");

        require(
            _msgSender() == owner || ERCXExample.access(_msgSender(), _tokenId, permission),
            "ERCX: grant caller is not owner nor granted for this permission"
        );
        // _permissionMap[_tokenId][_from] =;
        _permissionMap[_tokenId][_to] = permission;
        emit Grant(_from, _to, _tokenId, permission, reason);
    }

    function revoke(address _from, address _to, uint256 _tokenId) external payable {
        address owner = ERC721.ownerOf(_tokenId);
        require(to != owner, "ERCX: revoke permission to current owner");

        delete _permissionMap[_tokenId][_to];
    }
}
