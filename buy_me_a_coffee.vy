# Get funds form users
# Sell the funds
# Set a minimum funding value in USD

# pragma version 0.4.0
# @ license: MIt
# @ author:ybtuti

interface AggregatorV3Interface:
    def decimals() -> uint256: view
    def description() -> String[1000]: view
    def version() -> uint256: view
    def latestAnswer() -> int256: view

MINIMUM_USD: public(constant(uint256)) = as_wei_value(5, "ether")
PRICE_FEED: public(immutable(AggregatorV3Interface)) # 0x694AA1769357215DE4FAC081bf1f309aDC325306 Sepolia
OWNER: public(immutable(address))
PRECISION: constant(uint256) = 1 * (10 ** 18)
funders: public(DynArray[address, 1000])

funder_to_amount_funded: public(HashMap[address, uint256])

# Keep track of the people who send us money
# How much they sent us


@deploy
def __init__(price_feed_address: address):
    PRICE_FEED = AggregatorV3Interface(price_feed_address)
    OWNER = msg.sender

@external
@payable
def fund():
    self._fund()

@internal
@payable
def _fund():
    """Allows users to send money to this contract
    Have minimum $ send

    """
    usd_value_of_eth: uint256 = self._get_eth_to_usd_rate(msg.value)
    assert usd_value_of_eth >= MINIMUM_USD, "you must spend more Eth"
    self.funders.append(msg.sender)
    self.funder_to_amount_funded[msg.sender] +=msg.value

@external
def withdraw():
    """Take the money out of the contract, that people sent via the fund function

    How do we make sure only we can pull the money out?
    """
    assert msg.sender == OWNER, "Not the contract owner"
    # send(OWNER, self.balance)
    raw_call(OWNER, b"", value = self.balance)
    for funder: address in self.funders:
        self.funder_to_amount_funded[funder] = 0
    self.funders = []

@internal
@view
def _get_eth_to_usd_rate(eth_amount: uint256) -> uint256:
    # Address: 0x694AA1769357215DE4FAC081bf1f309aDC325306
    # ABI
    """
    Somebody sent 0.01 ETH for us to buy coffee.
    Is that more or less than $5
    """
    price: int256 = staticcall PRICE_FEED.latestAnswer() # 360964000000
    # 8 decimals
    # eth_amount_in_usd
    eth_price: uint256 = convert(price, uint256) * (10 ** 10)

    eth_amount_in_usd: uint256 = eth_amount * eth_price // (PRECISION)
    return eth_amount_in_usd

@external
@view
def get_eth_to_usd_rate(eth_amount: uint256) -> uint256:
    return self._get_eth_to_usd_rate(eth_amount)

@external
@payable
def __default__():
    self._fund()






# @external
# @view
# def get_price()-> int256:
#     price_feed: AggregatorV3Interface = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306)
#     return staticcall price_feed.latestAnswer()


