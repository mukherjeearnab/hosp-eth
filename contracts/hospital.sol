pragma solidity ^0.5.13;

contract Hospital {
    string hospitalName;                                        // String to store Name of the Hospital
    address public admin;                                       // Address of Ceator & Administrator of the contract
    bytes32[] patients;                                         // List of Patient ID's (HASH of PatientID)
    mapping (address => bool) public doctors;                   // Mapping for Doctors
    mapping (address => bool) public moderators;                // Mapping for Moderators
    mapping (bytes32 => patientProfile) public patientMap;      // Mapping to store (Patient's Address) => (Patient's Details)
    mapping (address => doctorsProfile) public doctorsMap;      // Mapping to store (Doctor's Address) => (Doctor's Details)
    mapping (bytes32 => prescription) public prescriptionMap;   // Mapping to store (Prescription ID) => (Prescription Details)

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
        string ID;                      // Doctor's Hospital ID
        uint8 gender;                   // Doctor's Gender
        uint16 height;                  // Doctor's Height (in Centimeters)
        uint16 weight;                  // Doctor's Weight (in Kilograms)
        string bloodGroup;              // Doctor's Blood-Group (as O+, A-, AB+ etc.)
        bytes32 licience;               // Doctor's HASH of licience stored in Swarm
        bytes32[] prescriptions;        // Doctor's List of Prescriptions Prescribed
    }

    // Structure to store details of a Prescriptions
    struct prescription {
        address doctor;                 // Address of Doctor who prescribed
        bytes32 patient;                // ID of Patient prescribes for
        uint timestamp;                 // Unix Timestamp of init. of Prescription
        string prescriptionContent;     // String/JSON of Prescription content
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
    }

    // Function to Add new Patient
    function addPatient(bytes32 _pID, string memory _name, uint _DoB,
                        uint8 _gender, uint16 _height, uint16 _weight,
                        string memory _bloodGroup) public {
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

        patientMap[_pID].prescriptions.push(bytes32("0xe7751cfabff66e60992e8d4dc3caf6a9")); //TEST
    }

    // Function to return the List of Prescriptions of a Patient
    function ret(bytes32 _pID) public view returns(bytes32[] memory) {
        return patientMap[_pID].prescriptions;
    }

    // Function to self-destruct ONLY FOR TESTING
    function kill() public onlyAdmin {
        selfdestruct(address(uint160(admin)));
    }
}