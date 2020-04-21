pragma solidity ^0.5.13;

import "./prescription.sol";

contract Hospital {

    PrescriptionVault public prescriptionVault;                 // PrescriptionVault Contract
    string public hospitalName;                                 // String to store Name of the Hospital
    address public admin;                                       // Address of Ceator & Administrator of the contract
    bytes32[] patients;                                         // List of Patient ID's (HASH of PatientID)
    mapping (address => bool) public doctors;                   // Mapping for Doctors
    mapping (address => bool) public moderators;                // Mapping for Moderators
    mapping (bytes32 => patientProfile) public patientMap;      // Mapping to store (Patient's Address) => (Patient's Details)
    mapping (address => doctorsProfile) public doctorsMap;      // Mapping to store (Doctor's Address) => (Doctor's Details)

    // Structure to store details of a Patients
    struct patientProfile {
        string name;                    // Patient's Name
        uint DoB;                       // Patient's Date of Birth (in Unix Timestamp)
        uint8 gender;                   // Patient's Gender (0 => Male, 1 => Female, 2 => Other)
        uint16 height;                  // Patient's Height (in Centimeters)
        uint16 weight;                  // Patient's Weight (in Kilograms)
        string bloodGroup;              // Patient's Blood-Group (as O+, A-, AB+ etc.)
        bytes32[] prescriptions;        // Patient's List of Prescriptions
    }

    // Structure to store details of a Doctors
    struct doctorsProfile {
        string name;                    // Doctor's Name
        string ID;
        uint DoB;                      // Doctor's Hospital ID
        uint8 gender;                   // Doctor's Gender
        uint16 height;                  // Doctor's Height (in Centimeters)
        uint16 weight;                  // Doctor's Weight (in Kilograms)
        string bloodGroup;              // Doctor's Blood-Group (as O+, A-, AB+ etc.)
        bytes32[] prescriptions;        // Doctor's List of Prescriptions Prescribed
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Sender NOT Admin.");          // Check if Sender is Admin
        _;
    }

    modifier onlyModerator() {
        require(moderators[msg.sender], "Sender NOT Moderator.");   // Check if Sender is Moderator
        _;
    }

    modifier onlyDoctor() {
        require(doctors[msg.sender], "Sender NOT Doctor.");         // Check if Sender is Doctor
        _;
    }

    // Constructor to create the Contract
    constructor(string memory _hospitalName) public {
        admin = msg.sender;             // Setting the Admin
        hospitalName = _hospitalName;   // Setting the Hospital Name
        patients = new bytes32[](0);    // Init. of bytes32[] patients List
        prescriptionVault = new PrescriptionVault(_hospitalName);
    }

    // Function to Fund the Contract
    function fundME() public payable onlyAdmin { }

    // Function to Add new Moderator
    function addModerator(address _modID) public onlyAdmin {
        moderators[_modID] = true;
    }

    // Function to Add new Patient
    function addPatient(bytes32 _pID, string memory _name, uint _DoB,
                        uint8 _gender, uint16 _height, uint16 _weight,
                        string memory _bloodGroup) public onlyModerator {
        patientProfile memory newPatient = patientProfile({
            name: _name,
            DoB: _DoB,
            gender: _gender,
            height: _height,
            weight: _weight,
            bloodGroup: _bloodGroup,
            prescriptions: new bytes32[](0)
        });
        patients.push(_pID);                // Push PatientID to patients List
        patientMap[_pID] = newPatient;      // Add newPatient to patientMap
    }

    // Function to Add new Doctor
    function addDoctor(address _pID, string memory _ID, string memory _name, uint _DoB,
                        uint8 _gender, uint16 _height, uint16 _weight,
                        string memory _bloodGroup) public onlyModerator {
        doctorsProfile memory newDoctor = doctorsProfile({
            ID: _ID,
            name: _name,
            DoB: _DoB,
            gender: _gender,
            height: _height,
            weight: _weight,
            bloodGroup: _bloodGroup,
            prescriptions: new bytes32[](0)
        });
        doctors[_pID] = true;              // Add Doctor's Address to doctors mapping
        doctorsMap[_pID] = newDoctor;      // Add newDoctor to doctorsMap
    }

    // Function to Edit a Patient
    function editPatient(bytes32 _pID, string memory _name, uint _DoB,
                        uint8 _gender, uint16 _height, uint16 _weight,
                        string memory _bloodGroup) public onlyModerator {
        patientMap[_pID].name = _name;
        patientMap[_pID].DoB = _DoB;
        patientMap[_pID].gender = _gender;
        patientMap[_pID].height = _height;
        patientMap[_pID].weight = _weight;
        patientMap[_pID].bloodGroup = _bloodGroup;
    }

    // Function to Edit a Doctor
    function editDoctor(address _pID, string memory _ID, string memory _name, uint _DoB,
                        uint8 _gender, uint16 _height, uint16 _weight,
                        string memory _bloodGroup) public onlyModerator {
        doctorsMap[_pID].ID = _ID;
        doctorsMap[_pID].name = _name;
        doctorsMap[_pID].DoB = _DoB;
        doctorsMap[_pID].gender = _gender;
        doctorsMap[_pID].height = _height;
        doctorsMap[_pID].weight = _weight;
        doctorsMap[_pID].bloodGroup = _bloodGroup;
    }

    // Function to Remove a Moderator
    function removeModerator(address _moderator) public onlyAdmin {
        moderators[_moderator] = false;
    }

    // Function to Remove a Doctor
    function removeDoctor(address _doctor) public onlyModerator {
        delete doctors[_doctor];
    }

    // Function to Add new Prescription
    function addNewPrescription(bytes32 _presID, address _doctor,
                                bytes32 _patient, uint _timestamp,
                                string memory _content) public onlyDoctor {
        prescriptionVault.addNewPrescription(_presID, _doctor, _patient, _timestamp, _content);
        doctorsMap[_doctor].prescriptions.push(_presID);
        patientMap[_patient].prescriptions.push(_presID);
    }

    // Function to return the List of Prescriptions of a Patient
    function retPatientPrescriptions(bytes32 _pID) public view returns(bytes32[] memory) {
        return patientMap[_pID].prescriptions;
    }

    // Function to return the List of Prescriptions of a Doctor
    function retDoctorsPrescriptions(address _pID) public view returns(bytes32[] memory) {
        return doctorsMap[_pID].prescriptions;
    }

    // Function to self-destruct ONLY FOR TESTING
    function kill() public onlyAdmin {
        prescriptionVault.kill();
        selfdestruct(address(uint160(admin)));
    }
}