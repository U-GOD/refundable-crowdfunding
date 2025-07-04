// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Refundable Crowdfunding
/// @notice Contributors can fund a project and get refunds if the funding goal isn't met by the deadline
contract RefundableCrowdfunding {
    /// @notice Owner of the campaign (the one who can withdraw funds)
    address public owner;

    /// @notice Funding goal in wei
    uint256 public goal;

    /// @notice Deadline timestamp (UNIX time)
    uint256 public deadline;

    /// @notice Total amount contributed by all users
    uint256 public totalContributed;

    /// @notice Track each contributor's amount
    mapping(address => uint256) public contributions;

    /// @notice Track if funding goal was reached
    bool public isFunded;

    /// @notice Track if funds have been claimed by the owner
    bool public fundsClaimed;

    /// @notice Event emitted when someone contributes
    event ContributionReceived(address contributor, uint256 amount);

    /// @notice Sets the campaign goal and deadline
    /// @param _goal The target amount in wei to raise
    /// @param _duration Duration of the campaign in seconds (e.g., 7 days * 24 * 60 * 60)
    constructor(uint256 _goal, uint256 _duration) {
        owner = msg.sender;
        goal = _goal;
        deadline = block.timestamp + _duration;
    }

    /// @notice Contribute funds to the campaign
    function contribute() external payable {
        require(block.timestamp < deadline, "Campaign has ended");
        require(totalContributed < goal, "Goal already reached");
        require(msg.value > 0, "Must send ETH");

        contributions[msg.sender] += msg.value;
        totalContributed += msg.value;

        emit ContributionReceived(msg.sender, msg.value);

        if (totalContributed >= goal) {
            isFunded = true;
        }
    }

    /// @notice Owner can withdraw funds only if goal is met
    function withdrawFunds() external {
        require(msg.sender == owner, "Only owner can withdraw");
        require(isFunded, "Goal not reached yet");
        require(!fundsClaimed, "Funds already claimed");

        fundsClaimed = true; // prevent re-withdrawal
        uint256 balance = address(this).balance;
        (bool success, ) = payable(owner).call{value: balance}("");
        require(success, "Withdrawal failed");
    }

    /// @notice Contributors can claim refund if goal not reached by deadline
    function refund() external {
        require(block.timestamp > deadline, "Deadline not reached yet");
        require(!isFunded, "Goal was met, no refunds");
        uint256 contributedAmount = contributions[msg.sender];
        require(contributedAmount > 0, "Nothing to refund");

        contributions[msg.sender] = 0;
        (bool success, ) = payable(msg.sender).call{value: contributedAmount}("");
        require(success, "Refund failed");
    }

    /// @notice Returns the total funds raised so far
    function getTotalFunds() external view returns (uint256) {
        return totalContributed;
    }

    /// @notice Returns how much a specific contributor sent
    function getContribution(address contributor) external view returns (uint256) {
        return contributions[contributor];
    }
}
