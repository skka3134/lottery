// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

contract Lottery  is Ownable, VRFConsumerBaseV2 {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;



    address Catcoin;
    address wallet;
    struct Project {
        uint256 amount;
        uint256 timeStart;
        uint256 timeEnd;
        address[] user;
        uint256 eventId;}
    uint256 eventId;
    address[] user;
    Project[] projects;
    mapping(address => bool) public userStakeBool;

    
    
    VRFCoordinatorV2Interface COORDINATOR;
    address VRFCoordinatorAddar =0x2Ca8E0C643bDe4C2E08ab1fA0da3401AdAD7734D;
    bytes32 keyHash =0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15;
    uint64 subId=12449;
    uint16 requestConfirmations = 3;
    uint32 callbackGasLimit = 2000000;
    uint32 numWords = 1;
    uint256 requestId;
    uint256 randomWord;

    constructor() VRFConsumerBaseV2(VRFCoordinatorAddar) {COORDINATOR = VRFCoordinatorV2Interface(VRFCoordinatorAddar);}

    function request() public {
        requestId = COORDINATOR.requestRandomWords(
            keyHash,
            subId,
            requestConfirmations,
            callbackGasLimit,
            numWords
        );
    }
    function fulfillRandomWords(uint256,uint256[] memory randomWords) internal override {
        randomWord=randomWords[0];
    }


    function setCatcoin(address Catcoin_) public onlyOwner {
        Catcoin = Catcoin_;
    }
    function setWallet(address wallet_) public onlyOwner {
        wallet = wallet_;
    }

    function start(uint256 amount_,uint256 timeStart_,uint256 timeEnd_) public {
        // IERC20(Catcoin).safeTransferFrom(msg.sender, wallet, amount_);
        projects.push(Project(amount_, timeStart_, timeEnd_, user,eventId));
        eventId=eventId+1;
    }

    function join(uint256 k) public {
        require(userStakeBool[msg.sender] == true, "not stake");
        require(block.timestamp >= projects[k].timeStart, "not start");
        projects[k].user.push(msg.sender);
    }

    function end(uint256 k) public onlyOwner {
        require(block.timestamp >= projects[k].timeEnd, "not End");
        request();
        // IERC20(Catcoin).safeTransferFrom(wallet,projects[k].user[randomWord],projects[eventId].amount);
    }
    
    function see(uint256 k) public view returns (address[] memory) {
        return projects[k].user;
    }

    function stake() public {
        require(userStakeBool[msg.sender] == false, "staked");
        // IERC20(Catcoin).safeTransferFrom(msg.sender, wallet, 1);
        userStakeBool[msg.sender] = true;
    }

    function withdraw() public {
        require(userStakeBool[msg.sender] == true, "not stake");
        // IERC20(Catcoin).safeTransferFrom(wallet, msg.sender, 1);
        userStakeBool[msg.sender] = false;
    }
}
