// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract UM_ChainBattles is ERC721URIStorage  {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    struct token_Properties{
        uint256 Level;
        uint256 Speed;
        uint256 Strength;
        uint256 Life;
    }

    mapping(uint256 => token_Properties) public tokenIdToProperties;

    constructor() ERC721 ("UM_Chain Battles", "UMCB"){}

    function generateCharacter(uint256 tokenId) public view returns(string memory){

        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            '<style>',
            '@import url("https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700display=swap");',
            '.base { fill: white; font-family: Poppins; font-size: 14px; } .heading{font-size: 16px;}</style>',
            '<rect width="100%" height="100%" fill="#27ae60" />',
            '<text x="50%" y="20%" class="base heading" style="color: #000000" dominant-baseline="middle" text-anchor="middle">',"Dynamic Warrior &#128526;",'</text>',
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">', "Level: ",getLevel(tokenId),'</text>',
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Speed: ",getSpeed(tokenId),'</text>',
            '<text x="50%" y="60%" class="base" dominant-baseline="middle" text-anchor="middle">', "Strength: ",getStrength(tokenId),'</text>',
            '<text x="50%" y="70%" class="base" dominant-baseline="middle" text-anchor="middle">', "Life: ",getLife(tokenId),'</text>',
            '</svg>'
        );
        return string(
            abi.encodePacked(
                "data:image/svg+xml;base64,",
                Base64.encode(svg)
            )    
        );
    }

    function getLevel(uint256 tokenId) public view returns (string memory) {
        token_Properties memory myStruct = tokenIdToProperties[tokenId];
        return (myStruct.Level).toString();
    }

    function getSpeed(uint256 tokenId) public view returns (string memory) {
        token_Properties memory myStruct = tokenIdToProperties[tokenId];
        return (myStruct.Speed).toString();
    }

    function getStrength(uint256 tokenId) public view returns (string memory) {
        token_Properties memory myStruct = tokenIdToProperties[tokenId];
        return (myStruct.Strength).toString();
    }

    function getLife(uint256 tokenId) public view returns (string memory) {
        token_Properties memory myStruct = tokenIdToProperties[tokenId];
        return (myStruct.Life).toString();
    }

    function getTokenURI(uint256 tokenId) public view returns (string memory){
        bytes memory dataURI = abi.encodePacked(
            '{',
                '"name": "Chain Battles #', tokenId.toString(), '",',
                '"description": "Battles on chain",',
                '"image": "', generateCharacter(tokenId), '"',
            '}'
        );
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(dataURI)
            )
        );
    }

    function mint() public {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        // tokenIdToProperties[newItemId] = 0;
            // Create an instance of the struct
    token_Properties memory properties = token_Properties({
        Level: 1,
        Speed: 100,
        Strength: 50,
        Life: 0
    });

    // Assign the struct reference to the storage mapping
    tokenIdToProperties[newItemId] = properties;
        _setTokenURI(newItemId, getTokenURI(newItemId));
    }

    function train(uint256 tokenId) public {
        require(_exists(tokenId), "Please use an existing token");
        require(ownerOf(tokenId) == msg.sender, "You must own this token to train it");

        // Declare myStruct as a storage reference
        token_Properties storage myStruct = tokenIdToProperties[tokenId];
        
        // tokenIdToProperties[tokenId] = currentLevel + 1;
        myStruct.Level += 1;
        myStruct.Speed += 30;
        string memory speedString = uint256ToString(myStruct.Speed);
        string memory kphString = " kph";
        string memory updatedSpeed = string(abi.encodePacked(speedString, kphString));
        myStruct.Speed = parseInt(updatedSpeed); // Update Speed with the parsed integer value
        myStruct.Strength += 25;
        myStruct.Life += 1;
        _setTokenURI(tokenId, getTokenURI(tokenId));
    }

    function uint256ToString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        
        uint256 temp = value;
        uint256 digits;
        
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        
        bytes memory buffer = new bytes(digits);
        
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        
        return string(buffer);
    }

    function parseInt(string memory _value) internal pure returns (uint256) {
    uint256 result = 0;
    for (uint256 i = 0; i < bytes(_value).length; i++) {
        if ((uint8(bytes(_value)[i]) >= 48) && (uint8(bytes(_value)[i]) <= 57)) {
            result = result * 10 + (uint8(bytes(_value)[i]) - 48);
        }
    }
    return result;
}

}   