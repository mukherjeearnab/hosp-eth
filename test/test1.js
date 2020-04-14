const HDWalletProvider = require('truffle-hdwallet-provider');
const Web3 = require('web3');
const interface = require('./abi.json')

const provider = new HDWalletProvider(
    'issue spoon spin crisp street tank unique despair apart like live vivid',
    'https://rinkeby.infura.io/v3/1ec6fd9491f8465cbc293b9d7367bf5f');
const web3 = new Web3(provider);

const deploy = async () => {
    accounts = await web3.eth.getAccounts();

    console.log('Attempting to deploy using Account - ', accounts[0]);
    
    contrac = new web3.eth.Contract(interface, '0xEA78cd7EE0909A5DE0E39944571DC52fBe52fA91'); //connecting with the contract


    console.log('Contract @ ', contrac.options.address);

	//await contrac.methods.add("0xe7751cfabff66e60992e8d4dc3caf6a9").send({from: accounts[0]}); //calling gas function
   /* await contrac.methods.addPatient("0x1234567890",
                                     "Quinn",
                                     11111,
                                     0,
                                     222,
                                     222,
                                     "O+", "0x123af").send({from: accounts[0]});*/
	
	const message = await contrac.methods.patientMap("0x1234567890").call(); //calling view function
    console.log(message);
    
    const essage = await contrac.methods.ret("0x1234567890").call(); //calling view function
    console.log(essage);



};

deploy();

