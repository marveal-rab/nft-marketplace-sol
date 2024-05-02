import { loadFixture } from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import hre from "hardhat";

describe("NFT Collection", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployFixture() {
    // Contracts are deployed using the first signer/account by default
    const [owner, otherAccount] = await hre.ethers.getSigners();

    const nftCollection = await hre.ethers.deployContract(
      "NFTCollecitonToken",
      [owner.address],
      {}
    );

    return { nftCollection, owner, otherAccount };
  }

  describe("Deployment", function () {
    it("Should deploy the contract", async function () {
      const { nftCollection, owner } = await loadFixture(deployFixture);
      expect(await nftCollection.owner()).to.equal(owner);
    });
  });

  describe("safe mint", function () {
    const name = "Test Token";
    const symbol = "TT";
    const uri =
      "https://ipfs.io/ipfs/QmUURppuo9yyyKrNDKxeC5eWG3w8yvZsdvb6wqAYhWBpcf";
    it("Should mint a token", async function () {
      const { nftCollection, owner } = await loadFixture(deployFixture);
      await nftCollection.safeMint(owner.address, uri, name, symbol);

      expect(await nftCollection.ownerOf(0)).to.equal(owner.address);
    });

    it("Should mint a token emit event", async function () {
      const { nftCollection, owner } = await loadFixture(deployFixture);
      await expect(nftCollection.safeMint(owner.address, uri, name, symbol))
        .to.emit(nftCollection, "CollectionCreated")
        .withArgs(0, name, symbol, owner.address);
    });
  });
});
