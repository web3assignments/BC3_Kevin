pragma solidity >=0.5.0 <0.6.0;

contract ForestZero {

    event NewTree(uint treeId, string location, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Tree {
        string location;
        uint dna;
    }

    Tree[] public trees;

    mapping (uint => address) public treeToForest;
    mapping (address => uint) forestTreeCount;

    function _createTree(string memory _location, uint _dna) private {
        uint id = trees.push(Tree(_location, _dna)) - 1;
        treeToForest[id] = msg.sender;
        forestTreeCount[msg.sender]++;
        emit NewTree(id, _location, _dna);
    }

    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomTree(string memory _location) public {
        require(forestTreeCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_location);
        _createTree(_location, randDna);
    }
}
