// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MyNFT is ERC721URIStorage,ERC721Enumerable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

     address immutable public admin;

     string[3] public roleUri;

     mapping(uint256 => Status) public tokenStatus;

     event SyncBlood(uint indexed tokenId,uint32 sheepBlood,uint32 sheepPower,uint32 wolfBlood,uint32 wolfPower,uint128 roleId);

     struct Token{
        Status status;

        uint256 tokenId;
     }


     struct Status{
        uint32 sheep_attack_power;
        uint32 sheep_blood;

        uint32 wolf_attack_power;

        uint32 wolf_blood;

        uint128 role_id;
     }

    constructor() ERC721("Brawl", "Brawl") {
        admin = msg.sender;

    }

    function initial(string memory lucky,string memory lazy,string memory beauty) public {
        require(msg.sender == admin,"No authorization");
        roleUri[0] = lucky;
        roleUri[1] = lazy;
        roleUri[2] = beauty;

        
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

        function _beforeTokenTransfer(
        address from,
        address to,
        uint tokenId,
        uint batchSize
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function safeMint(address to, uint128 roleId) public payable {
        require(msg.value >= 100 wei,"Insufficient ether amount");
        require(roleId < 3, "Unspported role");

        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);

         (bool success,) = admin.call{value: msg.value}("");
         if (!success) {
            revert("tansfer failed");
         }
            Status memory initialStatus = Status({
            sheep_attack_power: randomAttackPower(),
            sheep_blood: 100,
            wolf_attack_power: 30,
            wolf_blood: 100,
            role_id: roleId
         });

         emit SyncBlood(tokenId,initialStatus.sheep_blood,initialStatus.sheep_attack_power,
         initialStatus.wolf_blood,initialStatus.wolf_attack_power,initialStatus.role_id);
         tokenStatus[tokenId] = initialStatus;
    }

    function attack(uint256 tokenId) external {
    
        require(_isApprovedOrOwner(msg.sender,tokenId),"not authorized");

        Status storage status = tokenStatus[tokenId];
        require(status.sheep_blood > 0,"sheep is dead,can not attack wolf");
        if (status.wolf_blood > status.sheep_attack_power) {
        status.wolf_blood -= status.sheep_attack_power;
        } else {
            status.wolf_blood = 0;
        }
        if (status.wolf_blood > 0) {
            //wolf is alive,atack sheep
            if (status.sheep_blood <= status.wolf_attack_power) {
                status.sheep_blood = 0;
            } else {
            status.sheep_blood -= status.wolf_attack_power;
            }
        }
         emit SyncBlood(tokenId,status.sheep_blood,status.sheep_attack_power,
         status.wolf_blood,status.wolf_attack_power,status.role_id);
    }

    function randomAttackPower() private view returns (uint32) {
       return  uint32(uint256(keccak256(abi.encodePacked(block.timestamp,block.difficulty)))%20 + 20);
   }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
        delete tokenStatus[tokenId];
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        require(_exists(tokenId), " URI query for nonexistent token");
        return roleUri[tokenStatus[tokenId].role_id];
    }

        function last() public view returns (Token memory) {
        address owner = msg.sender;
        uint balance = balanceOf(owner);
        uint tokenId = tokenOfOwnerByIndex(owner,balance - 1);
        return Token(tokenStatus[tokenId],tokenId);
    }
}