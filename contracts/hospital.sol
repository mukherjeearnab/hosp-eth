pragma solidity ^0.5.13;

contract Hospital {
    string hospitalName;                                        // String to store Name of the Hospital
    address public admin;                                       // Address of Ceator & Administrator of the contract
    bytes10[] patients;                                         // List of Patient ID's
    mapping (address => bool) public doctors;                   // Mapping for Doctors
    mapping (address => bool) public moderators;                // Mapping for Moderators
    mapping (bytes10 => patientProfile) public patientMap;      // Mapping to store (Patient's Address) => (Patient's Details)
    mapping (address => doctorsProfile) public doctorsMap;      // Mapping to store (Doctor's Address) => (Doctor's Details)
    mapping (bytes64 => prescription) public prescriptionMap;   // Mapping to store (Prescription ID) => (Prescription Details)

    // Structure to store details of a Patients
    struct patientProfile {
        string name;                    // Patient's Name
        uint DoB;                       // Patient's Date of Birth (in Unix Timestamp)
        uint8 gender;                   // Patient's Gender (0 => Male, 1 => Female, 2 => Other)
        uint16 height;                  // Patient's Height (in Centimeters)
        uint16 weight;                  // Patient's Weight (in Kilograms)
        string bloodGroup;              // Patient's Blood-Group (as O+, A-, AB+ etc.)
        bytes64[] prescriptions;        // Patient's List of Prescriptions
    }

    // Structure to store details of a Doctors
    struct doctorsProfile {
        string name;                    // Doctor's Name
        string ID;                      // Doctor's Hospital ID
        uint8 gender;                   // Doctor's Gender
        uint16 height;                  // Doctor's Height (in Centimeters)
        uint16 weight;                  // Doctor's Weight (in Kilograms)
        string bloodGroup;              // Doctor's Blood-Group (as O+, A-, AB+ etc.)
        bytes64 licience;               // Doctor's HASH of licience stored in Swarm
        bytes64[] prescriptions;        // Doctor's List of Prescriptions Prescribed
    }

    // Structure to store details of a Prescriptions
    struct prescription {
        address doctor;                 // Address of Doctor who prescribed
        bytes10 patient;                // ID of Patient prescribes for
        uint timestamp;                 // Unix Timestamp of init. of Prescription
        string prescriptionContent;     // String/JSON of Prescription content
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Sender NOT Admin.");          // Check if Sender is Admin
        _;
    }

    modifier onlyModerator() {
        require(moderators(msg.sender), "Sender NOT Moderator.");   // Check if Sender is Moderator
        _;
    }

    modifier onlyDoctor() {
        require(doctors(msg.sender), "Sender NOT Doctor.");         // Check if Sender is Doctor
        _;
    }

    // Constructor to create the Contract
    constructor(string _hospitalName) public {
        admin = msg.sender;             // Setting the Admin
        hospitalName = _hospitalName;   // Setting the Hospital Name
        patients = new bytes10[](0);    // Init. of bytes10[] patients List
    }
}