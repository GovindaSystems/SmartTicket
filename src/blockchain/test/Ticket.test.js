const { expect, use } = require('chai');
const { ContractFactory } = require('ethers');
const TicketContract = require('../artifacts/contracts/Ticket.sol/Ticket.json');
const UserContract = require('../artifacts/contracts/User.sol/User.json');
const WalletContract = require('../artifacts/contracts/Wallet.sol/Wallet.json');
const NULL_ADDRESS = '0x0000000000000000000000000000000000000000';

describe('Ticket contract', function () {
  let Ticket, User, Wallet;
  let instance, userInstance, walletInstance;
  let deployer, user;
  let deployerAddress, userWallet;
  
  beforeEach(async function () {
    [deployer, user] = await ethers.getSigners();
    deployerAddress = await deployer.getAddress();
    
    Ticket = new ContractFactory(TicketContract.abi, TicketContract.bytecode, deployer);
    User = new ContractFactory(UserContract.abi, UserContract.bytecode, deployer);
    Wallet = new ContractFactory(WalletContract.abi, WalletContract.bytecode, deployer);
    
    instance = await Ticket.deploy();
    userInstance = await User.deploy();
    
    // Register a user and get their wallet address
    await userInstance.register("Test User", "test@example.com", "1234567890");
    const userInfo = await userInstance.getInfo("test@example.com");
    userWallet = userInfo.wallet;

    walletInstance = Wallet.attach(userWallet);
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
        expect(initialBalance).to.equal(1);
    
        const owner = await instance.ownerOf(0);
        expect(owner).to.equal(userWallet);

        instance.burn(userWallet, 0);

        const approvedAddress = await instance.getApproved(0);
        expect(deployerAddress).to.equal(approvedAddress);

        const finalBalance = await instance.balanceOf(userWallet);
        expect(finalBalance.toNumber()).to.equal(0);
      });

    });
    
  });

});
