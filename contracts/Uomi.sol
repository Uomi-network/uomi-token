// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract Uomi is ERC20, ERC20Permit, Ownable, AccessControl {

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    uint256 public constant MAX_SUPPLY = 21000000000 * 10 ** 18;

    event Bridged(
        address indexed from,
        address indexed to,
        uint256 indexed amount,
        uint256 destinationChainID
    );

    constructor() ERC20("UOMI", "UOMI") ERC20Permit("UOMI") Ownable(msg.sender) {
        _mint(msg.sender, 4919219238 * 10 ** decimals());
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
    }

    function mint(address to, uint256 amount) external onlyRole(MINTER_ROLE) {
        require(totalSupply() + amount <= MAX_SUPPLY, "Uomi: MAX_SUPPLY exceeded");
        _mint(to, amount);
    }

    function addAdmin(address account) external onlyRole(DEFAULT_ADMIN_ROLE) {
        _grantRole(DEFAULT_ADMIN_ROLE, account);
    }

    function removeAdmin(address account) external onlyRole(DEFAULT_ADMIN_ROLE) {
        _revokeRole(DEFAULT_ADMIN_ROLE, account);
    }

    function addMinter(address account) external onlyRole(DEFAULT_ADMIN_ROLE) {
        _grantRole(MINTER_ROLE, account);
    }

    function removeMinter(address account) external onlyRole(DEFAULT_ADMIN_ROLE) {
        _revokeRole(MINTER_ROLE, account);
    }

    function bridgeTo(
        address to,
        uint256 amount,
        uint256 destinationChainID
    ) external {
        burn(amount);
        emit Bridged(_msgSender(), to, amount, destinationChainID);
    }

    function burn(uint256 amount) internal {
        _burn(_msgSender(), amount);
    }

}
