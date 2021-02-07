const CCMachine = artifacts.require("CryptoCoinMachine");

contract('CryptoCoinMachine', (gamblers) => {
    it('should put atleast 1 ETH stake', async () => {
        const CCM = await CCMachine.deployed();
        assert.reverts(CCM.CryptoSpinned(), "Stake was less than 1 ETH");
    });
	it('should be more than 0 outcome', async () => {
		const CCM = await CCMachine.deployed();
		const CCMOutcome = await CCM.GetOutcomes();
		assert.notEqual(CCMOutcome.valueOf(), 0, "Outcome was not more than 0");
	});
	it('should emit Profitable event', async () => {
        const CCM = await CCMachine.deployed();
        let res = await CCM.CryptoSpinned({value: 1000000000000000000, from: gamblers[0]})
        assert.eventEmitted(res, "The event was emitted");
    });
	it('should not emit SelfDestruct function', async () => {
        const CCM = await CCMachine.deployed();
        assert.reverts(await CCM.SelfDestruct({from: gamblers[1]}), "The function was not emitted");
    });
    it('should give different output then input after processing', async () => {
        const CCM = await CCMachine.deployed();
        const res = await CCM.OracleNrProcessed(550)
        assert.notEqual(res.valueOf(), 550, "It did not give a different output");
    });
	it('should initially be 0 ETH on CCMachineBalance', async () => {
		const CCM = await CCMachine.deployed();
		const CCMBalance = await CCM.CCMachineBalance();
		assert.equal(CCMBalance.valueOf(), 0, "CCMachineBalance was more than 0 ETH");
	});
});