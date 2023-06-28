const { expect, use } = require('chai');
const { ContractFactory } = require('ethers');
const TicketContract = require('../artifacts/contracts/Ticket.sol/Ticket.json');
const AccessManagerContract = require('../artifacts/contracts/AccessManager.sol/AccessManager.json'); // Import the AccessManager contract
const NULL_ADDRESS = '0x0000000000000000000000000000000000000000';

describe('Ticket contract', function () {
  let Ticket;
  let instance;
  let accessManagerInstance; // Add accessManagerInstance
  let deployer;
  let user;
  let deployerAddress;
  let userAddress;

  beforeEach(async function () {
    [deployer, user] = await ethers.getSigners();
    deployerAddress = await deployer.getAddress();
    userAddress = await user.getAddress();
    Ticket = new ContractFactory(TicketContract.abi, TicketContract.bytecode, deployer);
    AccessManager = new ContractFactory(AccessManagerContract.abi, AccessManagerContract.bytecode, deployer); // Initialize AccessManager
    accessManagerInstance = await AccessManager.deploy();
    instance = await Ticket.deploy(accessManagerInstance.address);
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
      it('should mint token to an address', async function () {
        await accessManagerInstance.grantOrganizerRole(deployerAddress);
        await instance.createEvent("Test Event", "Test Location", Date.now(), ethers.utils.parseEther("1"), 100);
        const initialBalance = await instance.balanceOf(userAddress);
        await instance.mint(userAddress, 0);
        const finalBalance = await instance.balanceOf(userAddress);
        expect(finalBalance.toNumber() - initialBalance.toNumber()).to.equal(1);
      });

      it('should emit Transfer event', async function () {
        await instance.createEvent("Test Event", "Test Location", Date.now(), ethers.utils.parseEther("1"), 100);
        await expect(instance.mint(userAddress, 0))
          .to.emit(instance, 'Transfer')
          .withArgs(NULL_ADDRESS, userAddress, 0);
      });

      it('should trying mint token to an the 0x0 address', async function () {
        await instance.createEvent("Test Event", "Test Location", Date.now(), ethers.utils.parseEther("1"), 100);
        await expect(instance.mint(NULL_ADDRESS, 0)).to.be.revertedWith('ERC721: mint to the zero address');
      });
    });

    describe('burning', function () {
      it('should burn token from an address', async function () {
        await instance.createEvent("Test Event", "Test Location", Date.now(), ethers.utils.parseEther("1"), 100);
        await instance.mint(userAddress, 0);
        const initialBalance = await instance.balanceOf(userAddress);
        await instance.connect(user).burn(0);
        const finalBalance = await instance.balanceOf(userAddress);
        expect(initialBalance.toNumber() - finalBalance.toNumber()).to.equal(1);
      });

      it('should emit Transfer event', async function () {
        await instance.createEvent("Test Event", "Test Location", Date.now(), ethers.utils.parseEther("1"), 100);
        await instance.mint(userAddress, 0);
        await expect(instance.connect(user).burn(0))
          .to.emit(instance, 'Transfer')
          .withArgs(userAddress, NULL_ADDRESS, 0);
      });
    });
  });

});