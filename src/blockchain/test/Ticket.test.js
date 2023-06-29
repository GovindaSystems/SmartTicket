const { expect, use } = require('chai');
const { ContractFactory } = require('ethers');
const TicketContract = require('../artifacts/contracts/Ticket.sol/Ticket.json');
const UserContract = require('../artifacts/contracts/User.sol/User.json');
const NULL_ADDRESS = '0x0000000000000000000000000000000000000000';

describe('Ticket contract', function () {
  let Ticket, User;
  let instance, userInstance;
  let deployer, user;
  let deployerAddress, userWallet;
  
  beforeEach(async function () {
    [deployer, user] = await ethers.getSigners();
    deployerAddress = await deployer.getAddress();
    
    Ticket = new ContractFactory(TicketContract.abi, TicketContract.bytecode, deployer);
    User = new ContractFactory(UserContract.abi, UserContract.bytecode, deployer);
    
    instance = await Ticket.deploy();
    userInstance = await User.deploy();
    
    // Register a user and get their wallet address
    await userInstance.register("Test User", "test@example.com", "1234567890");
    const userInfo = await userInstance.getInfo("test@example.com");
    userWallet = userInfo.wallet;
  });

  describe('Deployment', function () {
    it('should set the correct Ticket name', async function () {
      expect(await instance.name()).to.equal('EventTicket');
    });

    it('should set the correct Ticket symbol', async function () {
      expect(await instance.symbol()).to.equal('ETKT');
    });

    it('should assign the initial balance of the deployer', async function () {
      expect(await instance.balanceOf(deployerAddress)).to.equal(0);
    });

    it('should revert when trying to get the balance of the 0x0 address', async function () {
      await expect(instance.balanceOf(NULL_ADDRESS)).to.be.revertedWith('ERC721: address zero is not a valid owner');
    });
  });

  describe('Operation', function () {
    this.timeout(50000);

    describe('minting', function () {
      it('should mint token to a user wallet address', async function () {
        await instance.createEvent("Test Event", "Test Location", Date.now(), ethers.utils.parseEther("1"), 100);
        const initialBalance = await instance.balanceOf(userWallet);
        await instance.mint(userWallet, 0);
        const finalBalance = await instance.balanceOf(userWallet);
        expect(finalBalance.toNumber() - initialBalance.toNumber()).to.equal(1);
      });

      it('should emit Transfer event', async function () {
        await instance.createEvent("Test Event", "Test Location", Date.now(), ethers.utils.parseEther("1"), 100);
        await expect(instance.mint(userWallet, 0))
          .to.emit(instance, 'Transfer')
          .withArgs(NULL_ADDRESS, userWallet, 0);
      });

      it('should trying mint token to an the 0x0 address', async function () {
        await instance.createEvent("Test Event", "Test Location", Date.now(), ethers.utils.parseEther("1"), 100);
        await expect(instance.mint(NULL_ADDRESS, 0)).to.be.revertedWith('ERC721: mint to the zero address');
      });

    });

    describe('burning', function () {
      it('should burn token from an address', async function () {
        await instance.createEvent("Test Event", "Test Location", Date.now(), ethers.utils.parseEther("1"), 100);
        await instance.mint(userWallet, 0);
        const initialBalance = await instance.balanceOf(userWallet);
    
        const owner = await instance.ownerOf(0);
        expect(owner).to.equal(userWallet);

        // Call the burn function through the user's wallet contract
        //await userWallet.burn(0);

        await instance.connect(userWallet).approve(deployerAddress, 0);

        await instance.burn(0);
    
        const finalBalance = await instance.balanceOf(userAddress);
        expect(initialBalance.toNumber() - finalBalance.toNumber()).to.equal(1);
      });

      it("2 - should burn token from an address", async function () {
        const User = await ethers.getContractFactory("User");
        const user = await User.deploy();
        await user.deployed();
      
        const Wallet = await ethers.getContractFactory("Wallet");
        const wallet = await Wallet.deploy();
        await wallet.deployed();
      
        const Ticket = await ethers.getContractFactory("Ticket");
        const ticket = await Ticket.deploy();
        await ticket.deployed();
      
        await user.register("Alice", "alice@example.com", "1234567890");
        const userInfo = await user.getInfo("alice@example.com");
      
        await ticket.createEvent("Concert", "Stadium", 1672444800, 100, 1000);
        await ticket.mint(userInfo.wallet, 0);
      
        const owner = await ticket.ownerOf(0);
        expect(owner).to.equal(userInfo.wallet);
              
        // Approve the contract to burn the token
        await ticket.connect(userInfo.wallet).approve(user.address, 0);
      
        // Burn the token
        await ticket.burn(0);
      
        await expect(ticket.ownerOf(0)).to.be.reverted;
      });
    });
    
  });

});
