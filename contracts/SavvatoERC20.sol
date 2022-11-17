// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
   * @title SavvatoERC20
   * @dev SavvatoERC20 Description
   * @custom:dev-run-script .
   */
contract SavvatoERC20 is ERC20 {

    address payable public deployingAddress;

    event memberBalanceChanged(address indexed addr, uint256 newAmount);

    constructor(string memory name_, string memory symbol_) ERC20(name_, symbol_) payable  {
        deployingAddress = payable(msg.sender);
    }

    receive() external payable { }

    function increaseBalance(address spender, uint256 amount) public returns(bool sufficient) {
        if (deployingAddress == payable(msg.sender)) {
            _mint(spender, amount);
            emit memberBalanceChanged(spender, balanceOf(spender));
        }

        return true;
    }

    function pot() public view returns(uint256) {
        return address(this).balance;
    }

    function portion(uint256 cashOutAmount) public view returns(uint256) {
        uint256 totalEthInThePot = address(this).balance;
        uint256 totalSupply = totalSupply();
        uint256 p = totalEthInThePot * (cashOutAmount / totalSupply);
        return p;
    }

    function cashOut(uint256 cashOutAmount) public payable returns(bool sufficient) {
        address payable destAddress = payable(msg.sender);

        uint256 totalEthInThePot = address(this).balance * 1.0;
        uint256 halfThePot = address(this).balance / 2;
        uint256 totalSupply = totalSupply();
        uint256 p = address(this).balance * (cashOutAmount / totalSupply);

        _burn(destAddress, cashOutAmount);

//        (bool success, ) = destAddress.call{value: p}("");
  //      require(success, "Failed to send Ether");

        destAddress.transfer(p);

        return true;
    }

}
