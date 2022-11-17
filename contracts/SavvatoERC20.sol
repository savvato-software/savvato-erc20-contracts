// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
   * @title SavvatoERC20
   * @dev Keeps a register of tokens to public addresses, and will send eth to that address when the address calls cashOut().
   * @custom:dev-run-script .
   */
contract SavvatoERC20 is ERC20 {

    address payable public deployingAddress;

    event memberBalanceChanged(address indexed addr, uint256 newAmount);

    constructor(string memory name_, string memory symbol_) ERC20(name_, symbol_) payable  {
        deployingAddress = payable(msg.sender);
    }

    receive() external payable { }

    function increaseBalance(address spender, uint256 amount) public returns(bool successful) {
        if (deployingAddress == payable(msg.sender)) {
            _mint(spender, amount);
            emit memberBalanceChanged(spender, balanceOf(spender));
        }

        return true;
    }

    function cashOut(uint256 cashOutAmount) public payable returns(bool successful) {
        address payable destAddress = payable(msg.sender);

        if (balanceOf(destAddress) >= cashOutAmount) {
            (bool success, ) = destAddress.call{value: (address(this).balance * cashOutAmount) / totalSupply()}("");
            require(success, "Failed to send Ether");

            _burn(destAddress, cashOutAmount);

            return true;
        }

        return false;
    }

}
