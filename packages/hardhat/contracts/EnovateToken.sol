// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;  


import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// learn more: https://docs.openzeppelin.com/contracts/4.x/erc20

contract EnovateToken is ERC20 {
    constructor() ERC20("ENOVATE", "ENV") {    
        _mint(msg.sender , 1000 * 10 ** 18 );
    }
}
