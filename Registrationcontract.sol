
// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (utils/cryptography/ECDSA.sol)

pragma solidity >=0.7.0 <0.9.0;


    contract RegistrarHolderWithDid {

    address public reg_user;
    string sigat;
    string[] did_submit;
    string[] did_submit1;
    string[] did_sub;
    string didholder1;
    address holder_addres;


    mapping (address=>holder)holders;

    struct holder {

        address didholder;
        string did; 
        string name; 
        bool isregistered;   

    }

    constructor() {
        reg_user = msg.sender;
    }



    modifier onlyRegistered {

        require(holders[msg.sender].isregistered, "You are not registered");
        _;

    }

    function push(string memory did, string memory holder_add, string memory sigature, string memory trans_hash) public {
        did_submit.push(did);
        holder_addres = stringToAddress(holder_add);
        did_submit.push(holder_add);
        did_submit.push(sigature);
        did_submit.push(trans_hash);

    }

    function getAll() public view returns (string[] memory)
    { 
        // for (uint j = 0; j < did_submit.length; j++){
        

        // }
    return did_submit;
    }

    function exists1(string memory num) public view returns (bool) {
    for (uint i = 0; i < did_submit.length; i++) {
        if (keccak256(abi.encode(did_submit[i])) == keccak256(abi.encode(num))) {
            return true;
        }
    }

    return false;
}
    function stringToAddress(string memory _address) public pure returns (address) {
    string memory cleanAddress = remove0xPrefix(_address);
    bytes20 _addressBytes = parseHexStringToBytes20(cleanAddress);
    return address(_addressBytes);
}

    function remove0xPrefix(string memory _hexString) internal pure returns (string memory) {
    if (bytes(_hexString).length >= 2 && bytes(_hexString)[0] == '0' && (bytes(_hexString)[1] == 'x' || bytes(_hexString)[1] == 'X')) {
        return substring(_hexString, 2, bytes(_hexString).length);
    }
    return _hexString;
    }

    function substring(string memory _str, uint256 _start, uint256 _end) internal pure returns (string memory) {
    bytes memory _strBytes = bytes(_str);
    bytes memory _result = new bytes(_end - _start);
    for (uint256 i = _start; i < _end; i++) {
        _result[i - _start] = _strBytes[i];
    }
    return string(_result);
    }

    function parseHexStringToBytes20(string memory _hexString) internal pure returns (bytes20) {
    bytes memory _bytesString = bytes(_hexString);
    uint160 _parsedBytes = 0;
    for (uint256 i = 0; i < _bytesString.length; i += 2) {
        _parsedBytes *= 256;
        uint8 _byteValue = parseByteToUint8(_bytesString[i]);
        _byteValue *= 16;
        _byteValue += parseByteToUint8(_bytesString[i + 1]);
        _parsedBytes += _byteValue;
    }
    return bytes20(_parsedBytes);
    }

    function parseByteToUint8(bytes1 _byte) internal pure returns (uint8) {
    if (uint8(_byte) >= 48 && uint8(_byte) <= 57) {
        return uint8(_byte) - 48;
    } else if (uint8(_byte) >= 65 && uint8(_byte) <= 70) {
        return uint8(_byte) - 55;
    } else if (uint8(_byte) >= 97 && uint8(_byte) <= 102) {
        return uint8(_byte) - 87;
    } else {
        revert(string(abi.encodePacked("Invalid byte value: ", _byte)));
    }
    }

    function registerHolders(address didholder,string memory did, string memory name) public returns(string memory) {

        holders[didholder].isregistered = false;
        bool validdid = false;
        bool validholder = false;
        for (uint i = 0; i < did_submit.length; i++) {
            validdid = validdid || iscompredid((abi.encodePacked(did_submit[0])),(abi.encodePacked(did)));
            validholder = validholder || iscompreholderadd((abi.encodePacked(holder_addres)),(abi.encodePacked(didholder)));
        }

        if(validdid && validholder)
        {

        holders[didholder] = holder(didholder,did,name,true);
        string memory validinvalid = "Valid DID of Holder 1 and Holder1 genered address provided";
        string memory registration = " and Holder1 Registration has been done successfully";
        string memory validinvalid_registration = append (validinvalid,registration);
        return validinvalid_registration;
        }
        else
        {
        holders[didholder] = holder(didholder,did,name,false);
        string memory validinvalid  = "Eithar Invalid  DID of Holder1 or Holder1 genered address provided ";
        return validinvalid ;
        }

    }

    function append(string memory a, string memory b) internal pure returns (string memory) {

    return string(abi.encodePacked(a, b));

    }

    function getHolderDetails(address didholder) public view returns (string memory,address,string memory,string memory){
        
        string memory validinvalid  = "User registered successfully with this information ";
        return(validinvalid, holders[didholder].didholder,holders[didholder].did,holders[didholder].name);
        //console.log("Registered for the user DID:" + holders[didholder].did);
    }

    function iscompredid(bytes memory did1, bytes memory did2) public pure returns (bool validDid){
     
        if ((keccak256(abi.encodePacked(did1))) == (keccak256(abi.encodePacked(did2)))){
            return true;
        }
    }

    function iscompresign(bytes memory sign1, bytes memory sign2) public pure returns (bool validSignature){
     
        if ((keccak256(abi.encodePacked(sign1))) == (keccak256(abi.encodePacked(sign2)))){
           return true;
        }
    }

    function iscomprehash(bytes memory hash1, bytes memory hash2) public pure returns (bool validhash){
     
        if ((keccak256(abi.encodePacked(hash1))) == (keccak256(abi.encodePacked(hash2)))){
            return true;
        }
    }

    function iscompreholderadd(bytes memory holderadd1, bytes memory holderadd2) public pure returns (bool validAddr){
     
        if ((keccak256(abi.encodePacked(holderadd1))) == (keccak256(abi.encodePacked(holderadd2)))){
            return true;
        }
    }

    function isValid_Signature_Hash(string memory hash, string memory signature) public view returns (string memory, bool) {

        string memory validinvalid;
        bytes memory sig2;
        sig2 = bytes(signature);
        bool sigverify = signatureverify(sig2);

        if (sigverify==true)
        {
        bool validsign = false;
        bool validhash = false;
        for (uint i = 0; i < did_submit.length; i++) {
            validsign = validsign || iscompresign(((abi.encodePacked(did_submit[2]))),(abi.encodePacked(signature)));
            validhash = validhash || iscomprehash(((abi.encodePacked(did_submit[3]))),(abi.encodePacked(hash)));
        }
        
        if(validsign && validhash)
        {
        string memory Valid1 ="Valid ECDSA Signature and  ";
        string memory Valid2 = "Valid AnonCred generated Verifier Signature and Hash value provided";
        validinvalid = append (Valid1,Valid2);
        bool val = true;
        return (validinvalid,val) ;
        }
        else
        {
        validinvalid = "Invalid AnonCred generated Verifier Signature or Hash value provided";
        bool val = false;
        return (validinvalid, val) ;
        }
        }
        else
        { 
        validinvalid = "Invalid ECDSA Signature provided";
        bool val = false;
        return (validinvalid, val) ;
        }
        

    }


    function signatureverify(bytes memory signature) public pure returns (bool t) {
        bytes32 message = ethMessageHash("TEST");
        //bool recovedvalue = recover(message, signature); 
        if (recover(message, signature) == true)
        {
            return true;
        }
        //return recover(message, sig) == addr;
    }

    /**
     * @dev Recover signer address from a message by using their signature
     * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
     * @param sig bytes signature, the signature is generated using web3.eth.sign()
     */
    function recover(bytes32 hash, bytes memory sig) internal pure returns (bool) {
        bytes32 r;
        bytes32 s;
        uint8 v;

        // Check the signature length
        if (sig.length == 0) {
            return false;
        }

        // Divide the signature in r, s and v variables
        // ecrecover takes the signature parameters, and the only way to get them
        // currently is to use assembly.
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            r := mload(add(sig, 32))
            s := mload(add(sig, 64))
            v := byte(0, mload(add(sig, 96)))
        }

        // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
        if (v < 27) {
            v += 26;
        }

        // If the version is correct return the signer address
        if (v != 27 && v != 28) {
        ecrecover(hash, v, r, s);
        return true;
        
            
        } else {
            // solium-disable-next-line arg-overflow
        return false;
            
        }
    }

    /**
    * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:" and hash the result
    */
    function ethMessageHash(string memory message) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", message)
        );
    }

    }

     