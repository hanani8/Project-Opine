/**
 * @file ballot.sol
 * @author Jackson Ng <jackson@jacksonng.org>
 * @date created 22nd Apr 2019
 * @date last modified 30th Apr 2019
 */

pragma solidity ^0.5.0;

contract Election {

    struct vote{
        address voterAddress;
        uint candidateId;
    }
    struct voter{
        string voterName;
        bool voted;
    }

    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    //uint private countResult = 0;
    //uint public finalResult = 0;
    // uint public totalVoter = 0;
    // uint public totalVote = 0;
    address public ballotOfficialAddress;
    uint public candidatesCount;
    // string public ballotOfficialName;
    // string public proposal;
    mapping(uint => vote) private votes;
    mapping(address => voter) public voterRegister;
    mapping(uint => Candidate) public candidates;
    enum State { Created, Voting, Ended }
	State public state;
    //creates a new ballot contract
	constructor() public {
        ballotOfficialAddress = msg.sender;
        // ballotOfficialName = _ballotOfficialName;
        // proposal = _proposal;
        state = State.Created;
        addCandidate("Candidate 1");
        addCandidate("Candidate 2");
    }
    modifier condition(bool _condition) {
        require(_condition,"There seems to be some problem with the condition");
		_;
	}

	modifier onlyOfficial() {
		require(msg.sender == ballotOfficialAddress,"This was not signed by the ballotOfficer");
		_;
	}

	modifier inState(State _state) {
		require(state == _state,"There was some problem with the state");
		_;
	}

    event voterAdded(address voter);
    event voteStarted();
    // event voteEnded(uint finalResult);
    event voteDone(address voter);
    //add candidate
    function addCandidate (string memory _name) private {
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
    }
    //add voter
    function addVoter(address _voterAddress, string memory _voterName)
        public
        inState(State.Created)
        onlyOfficial
    {
        voter memory v;
        v.voterName = _voterName;
        v.voted = false;
        voterRegister[_voterAddress] = v;
        totalVoter++;
        emit voterAdded(_voterAddress);
    }

    //declare voting starts now
    function startVote()
        public
        inState(State.Created)
        onlyOfficial
    {
        state = State.Voting;
        emit voteStarted();
    }

    //voters vote by indicating their choice (true/false)
    function doVote(uint _candidateId)
        public
        inState(State.Voting)
    {
        require(_candidateId > 0 && _candidateId <= candidatesCount,"That candidate doesn't exist");
        require(bytes(voterRegister[msg.sender].voterName).length != 0,"The voter is not authorized");
        require(!voterRegister[msg.sender].voted,"The voter already voted");
            voterRegister[msg.sender].voted = true;
            // v.choice = _choice;
            // if (_choice){
            //     countResult++; //counting on the go
            // }
            candidates[_candidateId].voteCount ++;
            emit voteDone(msg.sender);
            }
    //end votes
    function endVote()
        public
        inState(State.Voting)
        onlyOfficial
    {
        state = State.Ended;
        // finalResult = countResult; //move result from private countResult to public finalResult
        // emit voteEnded(finalResult);
    }
}