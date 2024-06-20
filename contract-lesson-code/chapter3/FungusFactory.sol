// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/access/Ownable.sol";

contract FungusFactory is Ownable {

    constructor() Ownable(msg.sender) {}

    event NewFungus(uint fungusId, string name, uint dna);

    // RED: 3, GREEN: 3, BLUE: 3, ALPHA: 3, Species: 2
    uint dnaDigits = 14;
    uint dnaModulus = 10 ** dnaDigits;
    uint cooldownTime = 1 minutes;

    struct Fungus {
        string name;
        uint dna;
        uint32 readyTime;
    }

    Fungus[] public fungi;

    mapping (uint => address) public fungusToOwner;
    mapping (address => uint) public ownerFungusCount;

    function _createFungus(string memory name, uint dna) internal {
        fungi.push(Fungus(name, dna, uint32(block.timestamp + cooldownTime)));
        uint id = fungi.length - 1;
        fungusToOwner[id] = msg.sender;
        ownerFungusCount[msg.sender]++;
        emit NewFungus(id, name, dna);
    }

    function _generateRandomDna(string calldata _str) private view returns (uint) {
        uint rand = uint(keccak256(bytes(_str)));
        uint dna = rand % dnaModulus;
        dna = dna - dna % 100;
        return dna;
    }

    function createRandomFungus(string calldata name) public {
        require(ownerFungusCount[msg.sender] == 0, "a fungus already exists");
        uint randDna = _generateRandomDna(name);
        _createFungus(name, randDna);
    }

    function getFungiByOwner(address owner) external view returns(uint[] memory) {
        uint[] memory result = new uint[](ownerFungusCount[owner]);

        uint counter = 0;
        for (uint i = 0; i < fungi.length; i++) {
            if (fungusToOwner[i] == owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }
}
