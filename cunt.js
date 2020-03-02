const Web3 = require('web3');
const Tx = require('ethereumjs-tx').Transaction;
const provider = new Web3.providers.HttpProvider("https://ropsten.infura.io/v3/88492df009e34eab951ae05a2e5f1d69");
const web3 = new Web3(provider);
const account1 = '0xD40Aa452fA828Ef237665683AdA951eF2329177c';

web3.eth.defaultAccount = account1;
const privateKey1 = Buffer.from('4571F98959D3F574C051C1285D60C1EC9424CCD7C04ECEF7BBC64D08105481D4', 'hex');
const abi = [
	{
		"inputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"constant": true,
		"inputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "candidates",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "id",
				"type": "uint256"
			},
			{
				"internalType": "string",
				"name": "name",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "voteCount",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "candidatesCount",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_candidateId",
				"type": "uint256"
			}
		],
		"name": "vote",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"name": "voters",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	}
];
const contract_Address = "0x63Df0F3F176bA9C9eB6aff447ebD599F1Ae7d06F";
const contract = new web3.eth.Contract(abi, contract_Address);
const myData = contract.methods.vote(1).encodeABI();
web3.eth.getTransactionCount(account1, (err, txCount) => {
// Build the transaction
  const txObject = {
    nonce:    web3.utils.toHex(txCount),
    to:       contract_Address,
    value:    web3.utils.toHex(web3.utils.toWei('0', 'ether')),
    gasLimit: web3.utils.toHex(2100000),
    gasPrice: web3.utils.toHex(web3.utils.toWei('6', 'gwei')),
    data: myData  
  }
    // Sign the transaction
    const tx = new Tx(txObject, {chain:'ropsten', hardfork: 'petersburg'});
    tx.sign(privateKey1);
    const serializedTx = tx.serialize();
    const raw = '0x' + serializedTx.toString('hex');
    // Broadcast the transaction
    const transaction = web3.eth.sendSignedTransaction(raw, (err, tx) => {
        if(err) return console.log(err);
        console.log(tx)
    });
});
