// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "../node_modules/@openzeppelin/contracts/utils/Counters.sol";
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";


contract SaadCreations is ERC721, Ownable, ERC721URIStorage {
 
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint public totalSupply=0;
    uint public startSaleTime;
    uint public endSaleTime;
    address public Owner;
    uint public lastPublickSaleTokenIndex = 0;
    string public baseURI = "https://ipfs.io/ipfs/";

    mapping(uint => uint) internal NFTPrice;

    constructor() ERC721("Saad Creations", "SCT") {
        Owner = msg.sender;
        
    }
    
    modifier isSaleOn() {
        require( block.timestamp >= startSaleTime && block.timestamp <  endSaleTime, "Sorry, Sale is over");
        _;
    }
    
        function _baseURI() internal view override returns (string memory) {
            return baseURI;
        }
        
        function setBaseUri(string memory newUri) external onlyOwner {
            baseURI = newUri;
        }
    
    
     // The following function is override required by Solidity.    
            function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

     // The following function is override required by Solidity.
    
    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

        function createNFT (address zct_owner, string memory zctURI, uint _price) public onlyOwner returns (string memory) {
        
        _tokenIds.increment();
        
         uint256 newNFTItemId = _tokenIds.current();
         require(newNFTItemId <= 100, "You have already minted 100 tokens.");
        _mint(zct_owner,newNFTItemId);
        totalSupply++;
        _setTokenURI(newNFTItemId, zctURI);

        _setNFTPrice(newNFTItemId, _price);

        return ("New NFT Created!");
        }   

        function _setNFTPrice(uint _id, uint _price)internal onlyOwner  {
            NFTPrice[_id] = _price;
        }


        function startSale() external onlyOwner returns(string memory){
        startSaleTime = block.timestamp;
        endSaleTime = startSaleTime + 30 days;
        return("Token sale has started now.");
        }
        
        function getNFTPriceById (uint _id) public view returns (uint){
            uint _NFTPriceByid = NFTPrice[_id];
            return  _NFTPriceByid;
        }

        function buyNFT(uint8 _tokenId) public payable isSaleOn returns(string memory){
        require(_exists(_tokenId),'Token does not exit');
        require(msg.value >= NFTPrice[_tokenId],"Your payment is short.");
        lastPublickSaleTokenIndex = _tokenId;
        return("Thank you the payment, please contact NFT contract owner/admin for NFT ownership transfer");
        }

        receive() external payable {}
    
}
