// SPDX-License-Identifier: MIT

pragma solidity 0.8.22;

import {IAnalyticsCenter} from "interfaces/IAnalitycsCenter.sol"; 
import {IDistributionCenter} from "interfaces/IDistributionCenter.sol";

contract Store {
    
    struct Goods {
        uint256 goodsId;
        uint256 amount;
        uint256 optimizedAmount;
        uint256 threshold;
        uint256 price;
        string name;
    }

    struct Order {
        uint256 orderId;
        uint256 goodsId;
        uint256 amount;
        bool status;
        bool inProgress;
    }

    address public manager;
    address public dc;
    address public ac;
    IDistributionCenter public distributionCenter;
    IAnalyticsCenter public analyticsCenter;

    mapping (uint256 => Goods) public warehouse;
    mapping (uint256 => Order) public ordersList;

    event CreatedDistributoinRequest(uint256 indexed goodsId, uint256 indexed amount);
    event Purchased(uint256 indexed goodsId, uint256 indexed amount);
    event OrderApproved(uint256 indexed orderId);

    constructor(address _distributionCenter, address _analyticsCenter) {
        manager = msg.sender;

        dc = _distributionCenter;
        ac = _analyticsCenter;
        
        distributionCenter = IDistributionCenter(_distributionCenter);
        analyticsCenter = IAnalyticsCenter(_analyticsCenter);
        distributionCenter.registerStore(address(this));
        analyticsCenter.registerStore(address(this));
    }

    function createDistributionRequest(uint256 goodsId, uint256 amount) external {
        require(msg.sender == manager || msg.sender == ac || msg.sender == address(this), "Store: not authorized to execute this operation.");
        require(amount > 0, "Store: amount must be greater than 0");
        require(warehouse[goodsId].amount <= warehouse[goodsId].threshold, "Store: threshold for goods exceeded.");
    
        require(analyticsCenter.registerDistributionRequest(goodsId, amount));

        emit CreatedDistributoinRequest(goodsId, amount);
    }

    function purchase(uint256 goodsId, uint256 amount) external {
        require(amount > 0, "Store: amount must be greater than 0.");
        require(warehouse[goodsId].amount >= amount, "Store: goods with this ID not found in the warehouse or not enough goods available for purchase.");

        Goods storage goods = warehouse[goodsId];

        goods.amount -= amount;
        
        if (goods.amount <= goods.threshold) {
            this.createDistributionRequest(goodsId, goods.optimizedAmount - goods.amount);
        }

        emit Purchased(goodsId, amount);
    }

    function approveOrder(uint256 orderId) external {
        require(msg.sender == manager || msg.sender == address(this), "Store: not authorized to execute this operation.");
        require(ordersList[orderId].orderId == orderId, "Order with that id does not exist in the list");

        Order storage order = ordersList[orderId];
        require(order.status != true, "Order is already done");
        require(order.inProgress != false, "Order is not in progress");

        Goods storage goods = warehouse[order.goodsId];
 
        order.status = true;
        goods.amount += order.amount;

        distributionCenter.approvedByStore(orderId);

        emit OrderApproved(orderId);
    }

    function getGoods(uint256 goodsId) external view returns (Goods memory) {
        require(warehouse[goodsId].goodsId == goodsId, "Store: goods with that id does not exist in the warehouse.");

        return warehouse[goodsId];
    }

    function getOrder(uint256 orderId) external view returns (Order memory) {
        require(ordersList[orderId].orderId == orderId, "Store: order with that id does not exist in the order list.");

        return ordersList[orderId]; 
    }
}