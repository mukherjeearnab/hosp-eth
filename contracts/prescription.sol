pragma solidity ^0.5.13;

contract PrescriptionVault {

    address public hospital;                                    // Address of Hospital
    string public hospitalName;                                 // String to store Name of the Hospital
    mapping (bytes16 => prescription) public prescriptionMap;   // Mapping to store (Prescription ID) => (Prescription Details)

    modifier onlyHospital() {
        require(msg.sender == hospital, "Sender NOT Hospital.");    // Check if Sender is Hospital
        _;
    }

    // Constructor to create the Contract
    constructor(string memory _hospitalName) public {
        hospital = msg.sender;          // Setting the Hospital
        hospitalName = _hospitalName;   // Setting the Hospital Name
    }

    // Structure to store details of a Prescriptions
    struct prescription {
        address doctor;                 // Address of Doctor who prescribed
        bytes16 patient;                // ID of Patient prescribes for
        uint timestamp;                 // Unix Timestamp of init. of Prescription
        string content;     // String/JSON of Prescription content
    }

    // Function to Add new Prescription
    function addNewPrescription(bytes16 _presID, address _doctor,
                                bytes16 _patient, uint _timestamp,
                                string memory _content) public onlyHospital {
        prescription memory newPrescription = prescription({
            doctor: _doctor,
            patient: _patient,
            timestamp: _timestamp,
            content: _content
        });
        prescriptionMap[_presID] = newPrescription;      // Add newPrescription to prescriptionMap
    }



    // Function to self-destruct ONLY FOR TESTING
    function kill() public onlyHospital {
        selfdestruct(address(uint160(hospital)));
    }
}