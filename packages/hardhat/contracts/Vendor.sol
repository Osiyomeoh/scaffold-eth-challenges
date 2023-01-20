pragma solidity 0.8.4; 
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./EnovateToken.sol";

contract Vendor is Ownable {

  //event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);

  EnovateToken  enovateToken;

  uint256 public constant tokensPerEth = 100;
  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens );

  constructor(address tokenAddress) {
    enovateToken = EnovateToken(tokenAddress);
  }

  // A payable buyTokens() function:
function buyTokens() public payable{
  require(msg.value > 0, "The value must be greater than 0");

  uint256 amtToTransfer = msg.value * tokensPerEth;

  enovateToken.transfer(msg.sender, amtToTransfer);
  emit BuyTokens(msg.sender, msg.value, amtToTransfer);



}
  // A withdraw() function that lets the owner withdraw ETH
  function withdraw() public onlyOwner {
    uint256 ownerBalance = address(this).balance;
     require(ownerBalance > 0, "Owner has no balance to withdraw");

     (bool sent, ) = msg.sender.call{value: ownerBalance}("");
     require(sent, "failed to send balance");
  }

  // A sellTokens(uint256 _amount) function:
  function sellTokens(uint256 tokensToSell) public {
    require(tokensToSell > 0, "Amount of tokens to sell must be greater than zero");

    uint256 userBalance = enovateToken.balanceOf(msg.sender);
    require(userBalance >= tokensToSell, "User has insufficient token amount to sell");

    uint256 ethAmtToTransfer = tokensToSell / tokensPerEth;
    uint256 ownerBalance = address(this).balance;
    require(ownerBalance >= ethAmtToTransfer, "Owner has insufficient balance");

    enovateToken.transferFrom(msg.sender, address(this), tokensToSell);

    (bool sent,) = msg.sender.call{value: ethAmtToTransfer }("");
    require(sent, "Failed to send ETH to the user");


  }

}
