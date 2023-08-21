import { Test, Test__factory } from '../typechain-types';
import { expect } from 'chai';
import { ethers } from 'hardhat';

describe('Test', () => {
  let instance: Test;

  beforeEach(async () => {
    const [deployer] = await ethers.getSigners();
    instance = await new Test__factory(deployer).deploy();
  });

  it('updates value in diamond storage by writing to app storage', async () => {
    expect(await instance.readFromAppStorage.staticCall()).to.be.false;
    expect(await instance.readFromDiamondStorage.staticCall()).to.be.false;

    await instance.writeToAppStorage();

    expect(await instance.readFromAppStorage.staticCall()).to.be.true;
    expect(await instance.readFromDiamondStorage.staticCall()).to.be.true;
  });

  it('updates value in app storage by writing to diamond storage', async () => {
    expect(await instance.readFromAppStorage.staticCall()).to.be.false;
    expect(await instance.readFromDiamondStorage.staticCall()).to.be.false;

    await instance.writeToDiamondStorage();

    expect(await instance.readFromAppStorage.staticCall()).to.be.true;
    expect(await instance.readFromDiamondStorage.staticCall()).to.be.true;
  });
});
