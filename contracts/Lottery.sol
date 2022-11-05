// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Lottery{
    address public manager;
    address payable[] public participants;

    constructor()
    {
        manager=msg.sender;
    }

    receive() external payable
    {
        require(msg.value==2 ether);
        participants.push(payable(msg.sender));
    }
    function getBalance() public view returns(uint)
    {
        require(msg.sender==manager);
        return address(this).balance;
    }
    function randomParticipants() public view returns(uint)
{
       return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,participants.length)));
    }
    function selectWinner() public
    {
        require(msg.sender==manager);
        require(participants.length>=3);
        uint randomData=randomParticipants();
        address payable winner;
        uint index=randomData% participants.length;
        winner=participants[index];
         winner.transfer(getBalance());
         participants=new address payable[](0);
    }
}