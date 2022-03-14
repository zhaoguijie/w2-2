// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

contract Score{
    address public teacher;
    address public teacherContract;
    mapping(address => uint256) student;

    constructor(address _teacherContract){
        // bytes memory bytecode = type(Teacher).creationCode;
        // bytes32 hash = keccak256(abi.encodePacked(bytes1(0xff), msg.sender, keccak256(abi.encode(123)), keccak256(bytecode)));
        // teacher = address(uint160(uint(hash)));

        // Teacher t = new Teacher{salt: keccak256(abi.encode(123))}();
        // teacher = address(t);
        teacher = msg.sender;  
        teacherContract = _teacherContract;
    }
   
    modifier onlyTeacher(){
        require(msg.sender == teacherContract, "Not Teacher1");
        _;
    }
    
    function ModifyGrades(address _student, uint256 score) external onlyTeacher {
        require(score <= 100, "Not Effective Results");
        student[_student] = score;
    }

    function QueryResults(address _student) public view returns (uint256){
        return student[_student];
    }
}

interface IScore{
    function ModifyGrades(address _student, uint256 score) external ;
    function QueryResults(address _student) external view returns (uint256);
}

contract Teacher{
    address public teacher;
    constructor (){
        teacher = msg.sender;
    }
    modifier onlyTeacher(){
        require(msg.sender == teacher, "Not Teacher2");
        _;
    }
    function ModifyGrades(address _contract, address _student, uint256 score) external onlyTeacher{
        // bytes memory modifyABI = abi.encodeWithSignature("ModifyGrades(address,uint256)", _student, score);
        // (bool success, ) =  _contract.delegatecall{gas: 60000}(modifyABI);
        //require(success, "It's False!");
        IScore(_contract).ModifyGrades(_student, score);
    }
    function QueryResults(address _contract, address _student) public view returns (uint256){
        return IScore(_contract).QueryResults(_student);
    }
}
