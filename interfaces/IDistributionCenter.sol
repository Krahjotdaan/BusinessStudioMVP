// SPDX-License-Identifier: MIT

pragma solidity 0.8.22;

interface IDistributionCenter {

    struct Order {
        address store;
        uint256 goodsId;
        uint256 amount;
        bool status;
    }

    event OrderCreated(address indexed store, uint256 indexed goodsId, uint256 indexed amount);
    event StoreRegistered(address indexed store);
    event VehicleSent(uint256 indexed vehicleId);
    event ApprovedByStore(uint256 indexed orderId);

    function createOrder(address store, uint256 goodsId, uint256 amount) external returns (Order memory);
    function registerStore(address store) external;
    function assingAndSendVehicle(uint256 orderId, uint256 vehicleId) external;
    function approvedByStore(uint256 orderId) external;
}