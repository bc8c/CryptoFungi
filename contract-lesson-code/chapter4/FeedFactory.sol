// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

contract FeedFactory {
    // dnaDigits 14자리 숫자    
    // 블록에 저장됨
    uint public dnaDigits = 14;
    uint public dnaModulus = 10 ** dnaDigits;

    struct Feed {
        string name;
        uint dna;
        uint price;
    }

    Feed[] public feeds;

    function _createFeed(string calldata name, uint dna) private {
        // 추가할 새 버섯의 정보는 name, dna -> 함수 호출시 매개변수로 입력됨
        // fungi 배열에 새로운 버섯 정보가 추가저장 되어야 함
        uint price = 0.0001 ether;
        feeds.push(Feed(name,dna,price));
    }

    function _generateRandomDna(string calldata _str) private view returns (uint) {
        // _str -> 해시함수에 넣고 돌린다. ==> 결과물 : 고정된 길이(같은 자릿수의 숫자)
      
        uint rand256 = uint(keccak256(bytes(_str)));
        uint dna = rand256 % dnaModulus;
        // RED 3, GREEN 3, BLUE 3, ALPHA 3, Species 2
        dna = dna - dna % 100 + 99;        
        return dna;
    }

    function createRandomFeed(string calldata name) public {
        // 먹이의 DNA를 생성해서 => randDna 변수에 넣는다.
        uint randDna = _generateRandomDna(name);
        _createFeed(name, randDna);
    }

    function getFeed(uint id) external view returns(string memory, uint, uint) {
        Feed memory feed = feeds[id];
        return (feed.name, feed.dna, feed.price);
    }
    // storage / memory / calldata
}