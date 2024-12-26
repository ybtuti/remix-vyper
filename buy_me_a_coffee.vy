# Get funds form users
# Sell the funds
# Set a minimum funding value in USD

# pragma version 0.4.0
# @ license: MIt
# @ author:ybtuti

@external
@payable
def fund():
    """Allows users to send money to this contract
    Have minimum $ send

    """
    assert msg.value == as_wei_value(1, "ether"), "you must spend more Eth"

@external
def withdraw():
    pass


