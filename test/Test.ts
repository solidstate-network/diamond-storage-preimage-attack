import { Test, Test__factory } from '../typechain-types';
import { expect } from 'chai';

describe('Test', () => {
  let instance: Test;

  beforeEach(async () => {
    const [deployer] = await ethers.getSigners();
    instance = await new Test__factory(deployer).deploy();
  });

  it('updates value in diamond storage by writing to app storage', async () => {
    expect(await instance.getFromAppStorage.staticCall()).to.be.false;
    expect(await instance.getFromDiamondStorage.staticCall()).to.be.false;

    await instance.setToAppStorage();

    expect(await instance.getFromAppStorage.staticCall()).to.be.true;
    expect(await instance.getFromDiamondStorage.staticCall()).to.be.true;
  });

  it('updates value in app storage by writing to diamond storage', async () => {
    expect(await instance.getFromAppStorage.staticCall()).to.be.false;
    expect(await instance.getFromDiamondStorage.staticCall()).to.be.false;

    await instance.setToDiamondStorage();

    expect(await instance.getFromAppStorage.staticCall()).to.be.true;
    expect(await instance.getFromDiamondStorage.staticCall()).to.be.true;
  });
});
