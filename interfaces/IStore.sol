// SPDX-License-Identifier: MIT

pragma solidity 0.8.22;

interface IStore {

    event CreatedDistributoinRequest(uint256 indexed goodsId, uint256 indexed amount);
    event Purchased(uint256 indexed goodsId, uint256 indexed amount);
    event OrderApproved(uint256 indexed orderId);
    
    function createDistributionRequest(uint256 goodsId, uint256 amount) external returns (uint256);
    function purchase(uint256 goodsId, uint256 amount) external;
    function approveOrder(uint256 orderId) external;
}