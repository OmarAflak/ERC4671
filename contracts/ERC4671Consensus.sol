// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/introspection/IERC165.sol";

import "./ERC4671.sol";
import "./IERC4671Consensus.sol";

abstract contract ERC4671Consensus is ERC4671, IERC4671Consensus {
    // Consensus voters addresses
    mapping(address => bool) private _voters;
    address[] private _votersArray;

    // Mapping from voter to mint approvals
    mapping(address => mapping(address => bool)) private _mintApprovals;

    // Mapping from owner to approval counts
    mapping(address => uint256) private _mintApprovalCounts;

    // Mapping from voter to invalidation approvals
    mapping(address => mapping(uint256 => bool)) private _invalidateApprovals;

    // Mapping from badgeId to invalidation counts
    mapping(uint256 => uint256) private _invalidateApprovalCounts;

    constructor (string memory name_, string memory symbol_, address[] memory voters_) ERC4671(name_, symbol_) {
        _votersArray = voters_;
        for (uint256 i=0; i<voters_.length; i++) {
            _voters[voters_[i]] = true;
        }
    }

    /// @notice Get voters addresses for this consensus contract
    /// @return Addresses of the voters
    function voters() public view virtual override returns (address[] memory) {
        return _votersArray;
    }

    /// @notice Cast a vote to mint a badge for a specific address
    /// @param owner Address for whom to mint the badge
    function approveMint(address owner) public virtual override {
        require(_voters[msg.sender], "You are not a voter");
        require(!_mintApprovals[msg.sender][owner], "You already approved this address");
        _mintApprovals[msg.sender][owner] = true;
        _mintApprovalCounts[owner] += 1;
        if (_mintApprovalCounts[owner] == _votersArray.length) {
            _resetMintApprovals(owner);
            _mint(owner);
        }
    }

    /// @notice Cast a vote to invalidate a badge for a specific address
    /// @param badgeId Identifier of the badge to invalidate
    function approveInvalidate(uint256 badgeId) public virtual override {
        require(_voters[msg.sender], "You are not a voter");
        require(!_invalidateApprovals[msg.sender][badgeId], "You already approved this address");
        _invalidateApprovals[msg.sender][badgeId] = true;
        _invalidateApprovalCounts[badgeId] += 1;
        if (_invalidateApprovalCounts[badgeId] == _votersArray.length) {
            _resetInvalidateApprovals(badgeId);
            _invalidate(badgeId);
        }
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC4671) returns (bool) {
        return 
            interfaceId == type(IERC4671Consensus).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    function _resetMintApprovals(address owner) private {
        for (uint256 i=0; i<_votersArray.length; i++) {
            _mintApprovals[_votersArray[i]][owner] = false;
        }
        _mintApprovalCounts[owner] = 0;
    }

    function _resetInvalidateApprovals(uint256 badgeId) private {
        for (uint256 i=0; i<_votersArray.length; i++) {
            _invalidateApprovals[_votersArray[i]][badgeId] = false;
        }
        _invalidateApprovalCounts[badgeId] = 0;
    }
}