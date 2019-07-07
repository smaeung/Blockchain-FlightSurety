pragma solidity ^0.4.24;

import "../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";

contract FlightSuretyData {
    using SafeMath for uint256;
    /********************************************************************************************/
    /*                                       Structure Data Variales                                      */
    /********************************************************************************************/
    struct Airline {
        bool isRegistered;
        uint fundingValues;
    }

    /********************************************************************************************/
    /*                                       DATA VARIABLES                                     */
    /********************************************************************************************/

    address private contractOwner;                                      // Account used to deploy contract
    bool private operational = true;                                    // Blocks all state changes throughout the contract if false

    mapping(address => Airline) airlines;
    uint256 private airlineCounts;

    // keep tracking of voters with registerd airline (key : airline , value : a list of voters)
    mapping(address => address[]) votersByAirline;
    /********************************************************************************************/
    /*                                       EVENT DEFINITIONS                                  */
    /********************************************************************************************/


    /**
    * @dev Constructor
    *      The deploying account becomes contractOwner
    */
    constructor(address _airlineAddress ) public 
    {
        contractOwner = msg.sender;
        airlines[_airlineAddress] = Airline({isRegistered: true, fundingValues: 0 });
        airlineCounts += 1; 
    }

    /********************************************************************************************/
    /*                                       FUNCTION MODIFIERS                                 */
    /********************************************************************************************/

    // Modifiers help avoid duplication of code. They are typically used to validate something
    // before a function is allowed to be executed.

    /**
    * @dev Modifier that requires the "operational" boolean variable to be "true"
    *      This is used on all state changing functions to pause the contract in 
    *      the event there is an issue that needs to be fixed
    */
    modifier requireIsOperational() 
    {
        require(operational, "Contract is currently not operational");
        _;  // All modifiers require an "_" which indicates where the function body will be added
    }

    /**
    * @dev Modifier that requires the "ContractOwner" account to be the function caller
    */
    modifier requireContractOwner()
    {
        require(msg.sender == contractOwner, "Caller is not contract owner");
        _;
    }

    /********************************************************************************************/
    /*                                       UTILITY FUNCTIONS                                  */
    /********************************************************************************************/

    function isAirlineRegistered(address _airlineAddress) external view requireIsOperational returns(bool){
        return airlines[_airlineAddress].isRegistered;
    }
    /**
     * to check whether there is any duplicated voters associated with the given airline
     */
    function isDuplicatedVoters(address _caller, address _airlineAddress) external view returns (bool) {
        address[] memory voters = votersByAirline[_airlineAddress];
        bool isDuplicated = false;
        for(uint i = 0; i < voters.length; i++){
            if(voters[i] == _caller){
                isDuplicated = true;
                break;
            }
        }
        return isDuplicated;
    }

    /**
     * to check whethr the gvien airlineAddress has required voters 
     */
    function isPassRequiredVoters(address _airlineAddress) external view returns (bool) {
        bool isPassVoters = false;
        // 50% of registered airline
        if(votersByAirline[_airlineAddress].length >= (airlineCounts / 2)){
            isPassVoters = true;
        }
        return isPassVoters;
    }
    /**
     * to register a voter (caller) assocaited with airline 
     */
    function registerVoter(address _caller, address _airlineAddress) external requireIsOperational {
        votersByAirline[_airlineAddress].push(_caller);
    }

    /**

     * to return a size of the voters associated with the airline
     */
    function getVoterSize(address _airlineAddress) external view returns (uint256) { 
        return votersByAirline[_airlineAddress].length; 
    }
    /**
    * @dev Get operating status of contract
    *
    * @return A bool that is the current operating status
    */      
    function isOperational() 
                            public 
                            view 
                            returns(bool) 
    {
        return operational;
    }


    /**
    * @dev Sets contract operations on/off
    *
    * When operational mode is disabled, all write transactions except for this one will fail
    */    
    function setOperatingStatus
                            (
                                bool mode
                            ) 
                            external
                            requireContractOwner 
    {
        operational = mode;
    }

    /********************************************************************************************/
    /*                                     SMART CONTRACT FUNCTIONS                             */
    /********************************************************************************************/

   /**
    * @dev Add an airline to the registration queue
    *      Can only be called from FlightSuretyApp contract
    *
    */   
    function registerAirline(address _airlineAddress)
                            external
                            requireIsOperational
    {
        airlines[_airlineAddress] = Airline({isRegistered: true, fundingValues: 0 });
        airlineCounts += 1; 
    }

    /**
    * returns a size of registered airline 
    */
    function getSizeRegisteredAirline() external view returns(uint256) {
        return airlineCounts;
    }

   /**
    * @dev Buy insurance for a flight
    *
    */   
    function buy
                            (                             
                            )
                            external
                            payable
    {

    }

    /**
     *  @dev Credits payouts to insurees
    */
    function creditInsurees
                                (
                                )
                                external
                                pure
    {
    }
    

    /**
     *  @dev Transfers eligible payout funds to insuree
     *
    */
    function pay
                            (
                            )
                            external
                            pure
    {
    }

   /**
    * @dev Initial funding for the insurance. Unless there are too many delayed flights
    *      resulting in insurance payouts, the contract should be self-sustaining
    *
    */   
    function fund
                            (   
                            )
                            public
                            payable
    {
    }

    function getFlightKey
                        (
                            address airline,
                            string memory flight,
                            uint256 timestamp
                        )
                        pure
                        internal
                        returns(bytes32) 
    {
        return keccak256(abi.encodePacked(airline, flight, timestamp));
    }

    /**
    * @dev Fallback function for funding smart contract.
    *
    */
    function() 
                            external 
                            payable 
    {
        fund();
    }


}

