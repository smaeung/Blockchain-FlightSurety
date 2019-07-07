var HDWalletProvider = require("truffle-hdwallet-provider");
var mnemonic = "kiss term globe bread picture noble belt ask cattle cloud bring carry";
//"tomorrow narrow food fiscal ribbon cinnamon scrap animal toy risk pet gas";
//candy maple cake sugar pudding cream honey rich smooth crumble sweet treat";

module.exports = {
  networks: {
    development: {
      provider: function() {
        return new HDWalletProvider(mnemonic, "http://127.0.0.1:8545/", 0, 50);
      },
      network_id: '*',
      gas: 6000000
    }
  },
  compilers: {
    solc: {
      version: "^0.4.24"
    }
  }
};