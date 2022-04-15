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
      assert.equal(name,'Copernicus Beer DAO');
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
      assert.equal(event.tokenId.toNumber(), 1, 'id must be 25');
      assert.equal(event.from, '0x0000000000000000000000000000000000000000', 'from is not correct');
      assert.equal(event.to, accounts[0], 'to is not correct');
    });
    it("has an URI", async () => {
      const result = await contract.tokenURI(1);
      assert.equal(result.toString(), 'URI::::'); 
    });
    // it("Set URI of Qrcode", async () => {
    //   assert.equal(await contract.qrcodeURI(1), ''); 
    //   await contract.setQrcodeURI(1,'HTTP://redirect/');
    //   const result = await contract.qrcodeURI(1);
    //   assert.equal(result.toString(), 'HTTP://redirect/'); 
    // });
  }); 

  describe("royalties", async () => {
    it("royalty fee of 10% of owner contract", async () => {
      const result = await contract.royaltyInfo(1,100);
      const owner = await contract.owner();

      assert.equal(result[0],owner);
      assert.equal(result[1],10);
    });
    it("Remove fee if there is no ownership", async () => {
      const owner = await contract.renounceOwnership();
      const result = await contract.royaltyInfo(1,100);
      assert.equal(result[0],'0x0000000000000000000000000000000000000000');
      assert.equal(result[1],0);
    });
  }); 


});