// SPDX-License-Identifier: MIT

pragma solidity 0.8.22;

interface IAnalyticalCenter {

    struct Order {
        address store;
        uint256 goodsId;
        uint256 amount;
        bool status;
    }

    event RegisteredDistributionRequest(uint256 indexed goodsId, uint256 indexed amount);
    event SetOptimizedPlan(address indexed store, uint256 indexed goodsId, uint256 indexed amount);
    event StoreRegistered(address indexed store);

    function registerDistributionRequest(uint256 goodsId, uint256 amount) external returns (bool);
    function setOptimizedPlan(address store, uint256 goodsId, uint256 amount) external;
    function registerStore(address store) external;
}