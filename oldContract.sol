pragma solidity 0.5.16;

contract Election {
    //Model a candidate
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }
     // Store accounts that have voted
    mapping(address => bool) public voters;
    //Read/Write Candidates
    mapping(uint => Candidate) public candidates;

    //Store Candidates Count
    uint public candidatesCount;

    function addCandidate (string memory _name) private {
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
    }

    constructor () public {
        addCandidate("Candidate 1");
        addCandidate("Candidate 2");
    }
     function vote (uint _candidateId) public {
        // require that they haven't voted before
        require(!voters[msg.sender],"Sender already Voted");

        // require a valid candidate
        require(_candidateId > 0 && _candidateId <= candidatesCount,"That Candidate doesn't exist");

        // record that voter has voted
        voters[msg.sender] = true;

        // update candidate vote Count
        candidates[_candidateId].voteCount ++;
    }
}