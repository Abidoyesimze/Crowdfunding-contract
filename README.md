Crowdfunding Smart Contract
This Solidity smart contract allows users to create and participate in decentralized crowdfunding campaigns. Each campaign has a title, description, fundraising goal, deadline, and a benefactor who receives the funds raised. Users can donate to any active campaign, and once the campaign's deadline is reached, the collected funds are transferred to the benefactor, regardless of whether the fundraising goal was met.

Features
Campaign Creation: Any user can create a crowdfunding campaign by specifying a title, description, fundraising goal, benefactor address, and campaign duration.
Donations: Users can donate to any active campaign before the deadline. The amount raised is tracked per campaign.
Campaign End: When the deadline of a campaign is reached, the contract transfers the raised funds to the benefactor.
Owner Withdrawal (Optional): The contract owner can withdraw leftover funds from the contract if necessary.
Event Logging: The contract logs events such as campaign creation, donations received, and campaign completion.
