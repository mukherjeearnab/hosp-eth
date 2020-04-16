pragma solidity ^0.5.13;

contract PrescriptionVault {

    address public hospital;                                    // Address of Hospital
    string public hospitalName;                                 // String to store Name of the Hospital
    mapping (bytes32 => prescription) public prescriptionMap;   // Mapping to store (Prescription ID) => (Prescription Details)

    modifier onlyHospital() {
        require(msg.sender == hospital, "Sender NOT Hospital.");    // Check if Sender is Hospital
        _;
    }

    // Constructor to create the Contract
    constructor(string memory _hospitalName) public {
        hospital = msg.sender;          // Setting the Hospital
    }

    // Structure to store details of a Prescriptions
    struct prescription {
        address doctor;                 // Address of Doctor who prescribed
        bytes32 patient;                // ID of Patient prescribes for
        uint timestamp;                 // Unix Timestamp of init. of Prescription
        string prescriptionContent;     // String/JSON of Prescription content
    }

    // Function to self-destruct ONLY FOR TESTING
    function kill() public onlyAdmin {
        selfdestruct(address(uint160(admin)));
    }
}