const { expect } = require('chai');
const { ethers } = require('hardhat');

describe('User Contract', function () {
  let User, user, addr1, addr2;
  
  beforeEach(async () => {
    User = await ethers.getContractFactory('User');
    [addr1, addr2, _] = await ethers.getSigners();
    user = await User.deploy();
    await user.deployed();
  });

  it('Should register a new user', async function () {
    await user.register('Alice', 'alice@example.com', '1234567890');
    //const userInfo = await user.getInfo('alice@example.com');
    //expect(userInfo.name).to.equal('Alice');
    //expect(userInfo.wallet).to.not.equal(ethers.constants.AddressZero);
  });

  it('Should not allow to register with the same email', async function () {
    await user.register('Alice', 'alice@example.com', '1234567890');
    await expect(user.register('Test', 'alice@example.com', '0987654321')).to.be.revertedWith('E-mail already exists');
  });

  it('Should set a user as an organizer', async function () {
    await user.register('Alice', 'alice@example.com', '1234567890');
    await user.setOrganizer('alice@example.com', 'document');
    const userInfo = await user.getInfo('alice@example.com');
    expect(userInfo.isOrganizer).to.equal(true);
  });
});
