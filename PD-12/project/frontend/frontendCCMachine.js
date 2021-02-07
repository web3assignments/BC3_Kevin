const CCMachineAbi=[
    {
		"inputs": [],
		"stateMutability": "payable",
		"type": "constructor"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "bool",
				"name": "profitable",
				"type": "bool"
			},
			{
				"indexed": false,
				"internalType": "uint",
				"name": "profitAmount",
				"type": "uint"
			}
		],
		"name": "earnProfits",
		"type": "event"
	},
	{
		"inputs": [],
		"name": "GetOracle",
		"outputs": [
			{
				"internalType": "bytes32",
				"name": "",
				"type": "bytes32"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "CryptoSpinned",
		"outputs": [],
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "CCMachineBalance",
		"outputs": [
			{
				"internalType": "uint",
				"name": "",
				"type": "uint"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint",
				"name": "",
				"type": "uint"
			}
		],
		"name": "outcome",
		"outputs": [
			{
				"internalType": "uint",
				"name": "",
				"type": "uint"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "oracle",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "OutcomeProcessed",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "GetOutcome",
		"outputs": [
			{
				"internalType": "uint[]",
				"name": "",
				"type": "uint[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_address",
				"type": "address"
			}
		],
		"name": "SetOracle",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "owner",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "SelfDestruct",
		"outputs": [],
		"stateMutability": "payable",
		"type": "function"
	},
]

// sources:
// https://web3js.readthedocs.io/en/v1.3.0/web3-eth-contract.html
// https://web3js.readthedocs.io/en/v1.3.0/web3-eth-accounts.html
// https://web3js.readthedocs.io/en/v1.3.0/web3-utils.html
// https://app.ens.domains

var gamblers;
var CCMachineAddress;

function Session(x){ return Number.parseFloat(x).toFixed(5); }

function SessionLogged(stringy, ...arguments) {
    var log = arguments.toString();
    document.getElementById("log").innerHTML += stringy + " " + log + "\n";
}

async function AsyncLoaded() {
    web3 = new Web3(Web3.givenProvider);
    await web3.eth.requestAccounts().catch(x => SessionLogged(x.message));
    const network = await web3.eth.net.getId().catch((reason) => SessionLogged(`Unable to reach Rinkeby Test Network ${reason}`));            
    if (typeof network === 'undefined' || network != 4) { SessionLogged("Only use Rinkeby Test Network"); return; }
    gamblers = await web3.eth.getAccounts();
    const name = "ccmachine.eth";
    CCMachineAddress = await web3.eth.ens.getAddress(name);  
    BalancesUpdated();
}     

window.addEventListener('load', AsyncLoaded);

async function CryptoSpinned(){
	const CCMachineContract = new web3.eth.Contract(CCMachineAbi, CCMachineAddress);
    var stake = document.getElementById("stake").value;
    var stakeToWei = web3.utils.toWei(stake);
    SessionLogged(`Stake: ${Session(stake)} ETH`);
	var response =  await CCMachineContract.methods.CryptoSpinned().send({from: gamblers[0], value:stakeToWei});

	BalancesUpdated();
    var gas = await web3.eth.getGasPrice()   
	var outcome = await CCMachineContract.methods.GetOutcome().call({from: gamblers[0]});
	SessionLogged(`Session outcome: ${outcome}`);
	BalancesUpdated();
	
    SessionLogged(`Gas payed: ${Session(web3.utils.fromWei((response.gasPayed * gas).toString(), 'ether'))} ETH`);    
    var profitable = response.events.earnProfits.returnValues['profitable'];
    var profitAmount = Session(web3.utils.fromWei(await response.events.earnProfits.returnValues['profitAmount'].toString(), 'ether'));
    if (profitable)
        SessionLogged(`Congratulations! You're profits are: ${profitAmount} ETH!`);
    else
		SessionLogged(`Better luck next time! The CryptoCoinMachine took: ${stake} ETH from you!`);

	document.querySelector('#cryptoSpin').style.visibility = "hidden";
	document.querySelector('#retrieveOutcome').style.visibility = "block";
}

async function OutcomeRetrieved() {
    const CCMachineContract = new web3.eth.Contract(CCMachineAbi, CCMachineAddress);
    await CCMachineContract.methods.GetOracle().send({from: gamblers[0]});
	SessionLogged('The Oracle is warming up...');
	await new Promise(r => setTimeout(r, 50000));
	SessionLogged(`The Oracle is almost ready... Hold on!`);
	await CCMachineContract.methods.OutcomeProcessed().send({from: gamblers[0]});
	document.querySelector('#cryptoSpin').style.visibility = "block";
	document.querySelector('#retrieveOutcome').style.visibility = "hidden";
	SessionLogged(`All set! Now spin the crypto coins like you've never spinned before!`)
}

async function BalancesUpdated(){
	var wei = await web3.eth.getBalance(gamblers[0])
	var ether = web3.utils.fromWei(wei, 'ether');
	document.getElementById("gamblerBalance").value = Session(ether).toString();    
	
	var weiCCMachine = await web3.eth.getBalance(CCMachineAddress)
	document.getElementById("cCMachineBalance").value = Session(web3.utils.fromWei(weiCCMachine, 'ether')); 
}
