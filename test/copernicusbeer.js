const CopernicusBeer = artifacts.require("CopernicusBeer");

contract("CopernicusBeer", accounts => {
  let contract;

  before(async () => {
    contract  = await CopernicusBeer.deployed();
  });

  describe("deployment", async () => {
    it("deploy successfully", async () => {
      const address = await contract.address;
      assert.notEqual(address, 0x0);
      assert.notEqual(address, '');
      assert.notEqual(address, null);
      assert.notEqual(address, undefined);
    });

    it("has a name", async () => {
      const name = await contract.name();
      assert.equal(name,'Copernicus Beer');
    });

    it("has a symbol", async () => {
      const symbol = await contract.symbol();
      assert.equal(symbol,'CPBEER');
    });

  }); 
 
  describe("minting", async () => {
    it("creates a new token", async () => {
      const result = await contract.createBeerNFT('URI::::');
      const totalSupply = await contract.totalSupply();
      assert.equal(totalSupply,1);
      const event = result.logs[0].args;
      assert.equal(event.tokenId.toNumber(), 1, 'id must be 1');
      assert.equal(event.from, '0x0000000000000000000000000000000000000000', 'from is not correct');
      assert.equal(event.to, accounts[0], 'to is not correct');
    });
    it("has an URI", async () => {
      const result = await contract.tokenURI(1);
      assert.equal(result.toString(), 'URI::::'); 
    });
    it("Set URI of Qrcode", async () => {
      assert.equal(await contract.qrcodeURI(1), ''); 
      await contract.setQrcodeURI(1,'HTTP://redirect/');
      const result = await contract.qrcodeURI(1);
      assert.equal(result.toString(), 'HTTP://redirect/'); 
    });
  }); 

});