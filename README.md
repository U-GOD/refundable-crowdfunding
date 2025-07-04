# Refundable Crowdfunding Smart Contract

This smart contract implements a simple crowdfunding mechanism on Ethereum-compatible chains. Contributors can fund a project, and if the funding goal is not met by the deadline, contributors can withdraw their funds.

---

## ✨ Features

- **Funding Goal:** The project defines a target amount to raise in ETH.
- **Deadline:** A timestamp after which funding ends.
- **Contributions:** Anyone can contribute ETH until the deadline.
- **Refunds:** If the goal is not reached, contributors can claim refunds.
- **Withdrawals:** If the goal is reached, the contract owner can withdraw funds.
- **State Management:** Tracks whether funds have been claimed and if the goal was met.

---

## 🚀 How It Works

1. **Deployment**
   - You deploy the contract specifying:
     - `_goal`: Target funding amount in wei.
     - `_duration`: Duration of the campaign in seconds.
   - Example:
     - `_goal`: `100000000000000000` (0.1 ETH)
     - `_duration`: `604800` (7 days)

2. **Contributing**
   - Users call `contribute()` and send ETH.
   - Contributions are tracked per address.

3. **Withdrawing Funds**
   - If the total contributions reach or exceed the goal, the owner can call `withdrawFunds()` to collect ETH.

4. **Claiming Refunds**
   - If the deadline passes and the goal was not met, contributors can call `refund()` to withdraw their individual contributions.

---

## 🧠 Contract Functions

### Public Variables
- `owner`: Address of the contract deployer.
- `goal`: Funding target in wei.
- `deadline`: Timestamp when funding ends.
- `totalContributed`: Total amount contributed.
- `fundsClaimed`: Whether the owner has withdrawn funds.
- `contributions`: Mapping of contributor addresses to amounts.

### Functions
- `contribute()`: Contribute ETH to the campaign.
- `withdrawFunds()`: Withdraw funds if the goal is reached.
- `refund()`: Refund contributions if the goal was not met.
- `getContribution(address)`: View a specific user's contribution.
- `getTotalFunds()`: View the total raised.

---

## 🛠️ Example Use Cases

- Community crowdfunding (e.g., neighborhood project).
- Raising pre-sale funds for an NFT collection.
- Collecting donations with accountability.
- Funding open-source development.

---

## 📝 How to Deploy and Test

1. Deploy the contract in Remix or Hardhat with the desired goal and duration.
2. Use `contribute()` to send test ETH.
3. Check `totalContributed` and `isFunded`.
4. After meeting the goal:
   - Owner calls `withdrawFunds()`.
5. After the deadline without meeting the goal:
   - Contributors call `refund()`.

---

## ✅ Security Notes

- Uses `call()` pattern for transfers to prevent re-entrancy issues.
- Always test on testnets before deploying to mainnet.

---

## 📄 License

MIT License
