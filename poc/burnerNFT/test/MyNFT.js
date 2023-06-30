const { expect } = require("chai");

describe("NFT", function() {
  it("Should mint a token, send it to the burner contract, and burn it", async function() {

    // Deploy the NFT contract
    const MyNFT = await ethers.getContractFactory("MyNFT");
    const myNFT = await MyNFT.deploy();
    await myNFT.deployed();

    // Deploy the burner contract
    const BurnerContract = await ethers.getContractFactory("BurnerContract");
    const burnerContract = await BurnerContract.deploy();
    await burnerContract.deployed();

    // Mint a new token to the owner
    await myNFT.mint(burnerContract.address);

    const initialBalance = await myNFT.balanceOf(burnerContract.address);

    expect(initialBalance).to.equal(1);
    const owner = await myNFT.ownerOf(0);

    expect(owner).to.equal(burnerContract.address);

    // Burn the token
    await burnerContract.burnToken(myNFT.address, 0);

    const finalBalance = await myNFT.balanceOf(burnerContract.address);

    expect(finalBalance).to.equal(0);
  });
});
