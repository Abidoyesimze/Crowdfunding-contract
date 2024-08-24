// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

contract Crowdfunding {
    // Structure to store details of a campaign
    struct Campaign {
        string title;
        string description;
        address payable benefactor;
        uint goal;
        uint deadline;
        uint amountRaised;
        bool ended;
    }

    
    event CampaignCreated(uint campaignId, string title, address benefactor, uint goal, uint deadline);
    event DonationReceived(uint campaignId, address donor, uint amount);
    event CampaignEnded(uint campaignId, uint amountRaised, address benefactor);

    address public owner; // Owner of the contract
    uint public campaignCount = 0; // Counter for campaigns

    mapping(uint => Campaign) public campaigns; 

    
    constructor() {
        owner = msg.sender;
    }

    // Modifier to allow only the contract owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can perform this action.");
        _;
    }

    
    modifier campaignExists(uint campaignId) {
        require(campaignId <= campaignCount && campaigns[campaignId].deadline != 0, "Campaign does not exist.");
        _;
    }

    
    function createCampaign(
        string memory _title,
        string memory _description,
        address payable _benefactor,
        uint _goal,
        uint _duration
    ) public {
        require(_goal > 0, "Campaign goal must be greater than zero.");
        
        uint deadline = block.timestamp + _duration;

        // Increment campaign count and create the new campaign
        campaignCount++;
        campaigns[campaignCount] = Campaign({
            title: _title,
            description: _description,
            benefactor: _benefactor,
            goal: _goal,
            deadline: deadline,
            amountRaised: 0,
            ended: false
        });

        emit CampaignCreated(campaignCount, _title, _benefactor, _goal, deadline);
    }

    // Donate to a specific campaign by campaign ID
    function donateToCampaign(uint campaignId) public payable campaignExists(campaignId) {
        Campaign storage campaign = campaigns[campaignId];
        require(block.timestamp < campaign.deadline, "Campaign has already ended.");
        require(msg.value > 0, "Donation must be greater than zero.");

        campaign.amountRaised += msg.value;

        emit DonationReceived(campaignId, msg.sender, msg.value);
    }

    // End the campaign and transfer funds to the benefactor
    function endCampaign(uint campaignId) public campaignExists(campaignId) {
        Campaign storage campaign = campaigns[campaignId];
        require(block.timestamp >= campaign.deadline, "Campaign is still active.");
        require(!campaign.ended, "Campaign has already ended.");

        // Mark the campaign as ended
        campaign.ended = true;

        // Transfer the amount raised to the benefactor, regardless of whether the goal was reached
        campaign.benefactor.transfer(campaign.amountRaised);

        emit CampaignEnded(campaignId, campaign.amountRaised, campaign.benefactor);
    }

    // Withdraw leftover funds (optional, for contract owner)
    function withdrawFunds() public onlyOwner {
        uint contractBalance = address(this).balance;
        require(contractBalance > 0, "No funds available for withdrawal.");
        payable(owner).transfer(contractBalance);
    }

    // Fallback function to accept any leftover payments
    fallback() external payable {}

    receive() external payable {}
}
