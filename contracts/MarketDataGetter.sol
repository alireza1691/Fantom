
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

interface AggregatorV3Interface {
  function decimals() external view returns (uint8);

  function description() external view returns (string memory);

  function version() external view returns (uint256);

  function getRoundData(uint80 _roundId)
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );

  function latestRoundData()
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );
}

contract MarketDataGetter {

    // Initializing Aggregator interface
AggregatorV3Interface internal immutable dataFeed;

    // These event will emit whenever price goes up or down higher than 5%
    // We can use them off chain to do whatever we want.
event IncreaseNotification(uint256 timeStamp, int price);
event DecreaseNotification(uint256 timeStamp, int price);
    // This event will emited with each updating price, so we can use this event to build historical data, or chart.
event NewData(uint256 timeStamp, int price);
 
    // Latest price will store in this variable so if someone wants to get price before passing a period of time, latest price should return
int private latestPrice;
    // Previous timeStamp of updating price will store in this variable
uint256 private previousTimeStamp;
    // This is the period of time that before passing, we can rely on latest price
    // Whenever previousTimeStamp + period > current timeStamp, price should update
uint256 private immutable period;

    // Constructor requires address of interface and period
    constructor(address _priceAddressAggregator,uint256 _period) {
        dataFeed = AggregatorV3Interface(
            _priceAddressAggregator
        );
        period = _period;
    }

    /**
     * Returns the latest answer form oracle.
     * Note that if the period was not passed, it returns the latest price.
     */
    function getData() public returns (int) {

        if (block.timestamp - period < previousTimeStamp) {
            return previousData();
        } else {
        (
            /* uint80 roundID */,
            int answer,
            /*uint startedAt*/,
            uint timeStamp,
            /*uint80 answeredInRound*/
        ) = dataFeed.latestRoundData();
        previousTimeStamp = timeStamp;
        latestPrice = answer;
        // If price 
        if (answer >= latestPrice + (latestPrice*5/100)) {
            emit IncreaseNotification(timeStamp, answer );
        }
        if (answer <= latestPrice - (latestPrice*5/100)) {
            emit DecreaseNotification(timeStamp, answer);
        }
        emit NewData(timeStamp, answer);
        return answer;
        }

        
        
    }

    // A getter for latestPrice variable
    function previousData() public view returns(int) {
        return latestPrice;
    }

    // This function will do something if one of the notification events, emmited.
    // If price goes up/down higher than 5% => notification event emited => offchain process => this function will call
    function doSomething() public {}


    // Also we can get price of another tokens using their AGGREGATOR address:
    function getDataByAddress(address aggAddress) public view returns (int, uint) {
        AggregatorV3Interface inst = AggregatorV3Interface(aggAddress);

        (
            /* uint80 roundID */,
            int answer,
            /*uint startedAt*/,
            uint timeStamp,
            /*uint80 answeredInRound*/
        ) = inst.latestRoundData();
        return (answer, timeStamp);

    }


}
