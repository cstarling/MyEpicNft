pragma solidity ^0.8.0;


import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

// We need to import the helper functions from the contract that we copy/pasted.
import { Base64 } from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage {
  bool public saleIsActive = true;
  uint256 public constant MAX_SUPPLY = 10000;
  uint256 public constant MAX_PUBLIC_MINT = 6;
  uint256 public constant PRICE_PER_TOKEN = 0.001 ether;
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

  string[] firstWords = ["Maple", "Hickory", "Oak", "Sap", "Cedar", "Ivory"];
  string[] secondWords = ["NGMI", "Fud", "Scam", "RugPull", "Dao", "NFT"];
  string[] thirdWords = ["Snickers", "Babe Ruth", "Reeses", "Twix", "Kisses", "Blash"];

  constructor() ERC721 ("SquareNFT", "SQUARE") {
    console.log("This is my NFT contract. Woah!");
  }


  function setSaleState(bool newState) public {
        saleIsActive = newState;
    }

  function getAmountMinted() public view returns (uint256) {
    return _tokenIds.current();
  }

  function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
    rand = rand % firstWords.length;
    return firstWords[rand];
  }

  function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
    rand = rand % secondWords.length;
    return secondWords[rand];
  }

  function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
    rand = rand % thirdWords.length;
    return thirdWords[rand];
  }

  function random(string memory input) internal pure returns (uint256) {
      return uint256(keccak256(abi.encodePacked(input)));
  }

  function makeAnEpicNFT(uint256 numberOfTokens) public payable {
    require(saleIsActive, "Sale must be active to mint tokens");
    require(PRICE_PER_TOKEN * numberOfTokens <= msg.value, "Ether value sent is not correct");
    for (uint256 i = 0; i < numberOfTokens; i++) {
      uint256 newItemId = _tokenIds.current();

      string memory first = pickRandomFirstWord(newItemId);
      string memory second = pickRandomSecondWord(newItemId);
      string memory third = pickRandomThirdWord(newItemId);
      string memory combinedWord = string(abi.encodePacked(first, second, third));

      string memory finalSvg = string(abi.encodePacked(baseSvg, combinedWord, "</text></svg>"));

      // Get all the JSON metadata in place and base64 encode it.
      string memory json = Base64.encode(
          bytes(
              string(
                  abi.encodePacked(
                      '{"name": "',
                      // We set the title of our NFT as the generated word.
                      combinedWord,
                      '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                      // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                      Base64.encode(bytes(finalSvg)),
                      '"}'
                  )
              )
          )
      );

      // Just like before, we prepend data:application/json;base64, to our data.
      string memory finalTokenUri = string(
        abi.encodePacked("data:application/json;base64,", json)
      );

      console.log("\n--------------------");
      console.log(
          string(
              abi.encodePacked(
                  "https://nftpreview.0xdev.codes/?code=",
                  finalTokenUri
              )
          )
      );
      console.log("--------------------\n");

      _safeMint(msg.sender, newItemId);
      
      // Update your URI!!!
      _setTokenURI(newItemId, finalTokenUri);
    
      _tokenIds.increment();
      
      console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
    }
  }
}