pragma solidity ^0.5.11;


/// @title Blocklogy Certificate Gerneration and Verification 
/// @author Jetso
/// @notice This contract is used for generation and verification of Blocklogy Certificate
contract BlocklogyCertificate {
    struct Certificate {
        uint256 userID;
        string name;
        string course;
        uint256 belt;
        uint256 percentile;
    }
    
    address public superAdmin;
    Certificate[] public certificateDatabase;
  
    mapping(address => bool) public isAdmin;

    event CertificateGenerated (
        uint256 indexed _certiID,
        uint256 indexed _userId, 
        string _name, 
        string _course, 
        uint256 _belt,
        uint256 _percentile
    );

    modifier onlyAdmin() {
        require(isAdmin[msg.sender], "Only Admin assigned by SuperAdmin can use this function");
        _;
    }
      
    modifier onlySuperAdmin() {
        require(msg.sender == superAdmin, "Only SuperAdmin can use this function");
        _;
    }

    constructor() public {
        superAdmin = msg.sender;
        isAdmin[msg.sender] = true;
    }
    
    /// @notice Add New Admin to issue certificate by superAdmin
    /// @param _adminAddress will take new admin address input
    function addAdmin(address _adminAddress) public onlySuperAdmin {
        isAdmin[_adminAddress] = true;
    }
    
    /// @notice superAdmin Deletes the existing Admin 
    /// @param _adminAddress will take admin address which needs to be removed   
    function removeAdmin(address _adminAddress) public onlySuperAdmin {
        isAdmin[_adminAddress] = false;
    }
    
    /// @notice views the latest certificate number
    /// @return latest certificate number issued by the Admin 
    function viewLatestCertificateNumber() public view returns (uint256) {
        return certificateDatabase.length-1;
    }
    
    /// @notice views the Total certificate issued
    /// @return total certificate issued by the Admin in Blockchain
    function getTotalCertificateCount() public view returns (uint256) {
        return certificateDatabase.length;
    }
    
    /// @notice This function will issue the certificate for the course in Blockchain
    /// @param _userId is the unique ID of each users
    /// @param _name inputs the name of each users
    /// @param _course inputs the course for which the certificate is issued
    /// @param _belt inputs the belt level of each course in integer
    /// @param _percentile inputs the percentage which he scored in the exam
    /// @return certificate number
    function issueCertificate(
        uint256 _userId, 
        string memory _name, 
        string memory _course, 
        uint256 _belt, 
        uint256 _percentile
    ) public onlyAdmin returns (uint256) {
        certificateDatabase.push(Certificate({
            userID: _userId,
            name: _name,
            course: _course,
            belt: _belt,
            percentile: _percentile
        }));
        
        emit CertificateGenerated(certificateDatabase.length - 1, _userId, _name, _course, _belt, _percentile);

        return certificateDatabase.length - 1;
    }
}