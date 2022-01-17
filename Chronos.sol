// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract Chronos {

    struct ticket {
        uint256  timestamp;
        uint256  callAt;
        address tokenAddress;
        address from;
        address to;
        uint256 value;
        uint256 fee;
        uint32  nonce;
    }

    address TOKEN_NAME;

    mapping(bytes32 => ticket) internal sig;
    mapping(address => uint32) public   nonceOf;
    mapping(address => mapping(address => address)) allowance;

    event TicketCreate(
        uint256  timestamp,
        uint256  callAt,
        address tokenAddress,
        address from,
        address to,
        uint256 value,
        uint256 fee,
        uint32  nonce
    );

    function calculateTicketHash(ticket memory _ticket) private pure returns (bytes32 hash) {
        hash = keccak256(abi.encodePacked(
            _ticket.callAt, 
            _ticket.timestamp, 
            _ticket.tokenAddress,
            _ticket.from,
            _ticket.to,
            _ticket.value,
            _ticket.fee,
            _ticket.nonce
        ));
    }
    function createTicket(
        uint256  _timestamp,
        address _tokenAddress,
        address _from,
        address _to,
        uint256 _value,
        uint256 _fee
    ) public returns (bytes32) {

        uint32 thisNonce = nonceOf[_from];
        nonceOf[_from]++;

        ticket memory _newTicket = ticket(
            _timestamp,
            block.timestamp,
            _tokenAddress,
            _from,
            _to,
            _value,
            _fee,
            thisNonce
        );
        bytes32 ticketHash = calculateTicketHash(_newTicket);
        sig[ticketHash] = _newTicket;

        emit TicketCreate(
            _timestamp,
            block.timestamp,
            _tokenAddress,
            _from,
            _to,
            _value,
            _fee,
            thisNonce
        );

        return ticketHash;
    }
}