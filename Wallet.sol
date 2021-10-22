pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract Wallet {

    constructor() public {
        // check that contract's public key is set
        require(tvm.pubkey() != 0, 101);
        // Check that message has signature (msg.pubkey() is not zero) and message is signed with the owner's private key
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    modifier checkOwnerAndAccept {
        // Check that inbound message was signed with owner's public key.
        // Runtime function that obtains sender's public key.
        require(msg.pubkey() == tvm.pubkey(), 100);

		// Runtime function that allows contract to process inbound messages spending
		// its own resources (it's necessary if contract should process all inbound messages,
		// not only those that carry value with them).
		tvm.accept();
		_;
	}

    /// Allows to transfer tons to the destination account.
    /// dest: Transfer target address. То, куда будет уходить перевод
    /// value: Nanotons value to transfer. Сумма, которую хотим перевести
    /// bounce: Flag that enables bounce message in case of target contract error. Отскок (по умолчанию true)
    

    function sendTransactionWithoutCommision(address dest, uint128 value, bool bounce) public pure checkOwnerAndAccept {
         // метод transfer, позволяющий осуществлять передачу, некоторые параметры определены сразу
        dest.transfer(value, bounce, 1); // флаг 1 - комиссия отдельно от суммы контракта (сверх суммы контракта)
    }
    function sendTransactionWithCommision(address dest, uint128 value, bool bounce) public pure checkOwnerAndAccept {
         // метод transfer, позволяющий осуществлять передачу, некоторые параметры определены сразу
        dest.transfer(value, bounce, 0); // флаг 0 - комиссия за передачу вычитается из переданных средств.
    }
    function sendTransactionAndDestroyWallet(address dest, uint128 value, bool bounce) public pure checkOwnerAndAccept {
         // метод transfer, позволяющий осуществлять передачу, некоторые параметры определены сразу
        dest.transfer(value, bounce, 160); // флаг 128+31=160 - отправить все деньги и уничтожить кошелек
    }
}