// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Blog {
  string public name;
  address public owner;

  using Counters for Counters.Counter;
  Counters.Counter private _postIds;

  struct Post {
    uint id;
    string title;
    string content;
    bool published;
  }
  /** create lookups for posts by id and by ipfs hash */
  mapping(uint => Post) public idToPost;
  mapping(string=> Post) public hashToPost;

  /** events facilitate comunication between smart contract and user interfaces */
  /** two benefits: we can create listeners for events in the client and also use them in The Graph */
  event PostCreated(uint id, string title, string content);
  event PostUpdated(uint id, string title, string content, bool published);

  modifier onlyOwner {
    require(msg.sender == owner, "Only the owner can call this function");
    _;
  }
  /* when the blog is deployed, give it a name */
  /* also set the creator as the owner of the contract */
  constructor(string memory _name) {
    console.log("Deploying a Blog with name:", _name);
    name = _name;
    owner = msg.sender;
  }

  function updateName(string memory _name) public {
    name = _name;
  }
  // TODO: meaning of doing so?
  /** transfers ownership of the contract to another address */
  function transferOwnership(address newOwner) public onlyOwner {
    owner = newOwner;
  }

  /** fetch an individual post by the content hash */
  function fetchPost(string memory hash) public view returns(Post memory) {
    return hashToPost[hash];
  }

  function createPost(string memory title, string memory hash) public onlyOwner {
    _postIds.increment();
    uint postId = _postIds.current();
    Post storage post = idToPost[postId];
    post.id = postId;
    post.title = title;
    post.content = hash;
    post.published = true;

    hashToPost[hash] = post;
    emit PostCreated(postId, title, hash);
  }

  function updatePost(uint postId, string memory title, string memory hash, bool published) public onlyOwner {
    Post storage post = idToPost[postId];
    post.title = title;
    post.content = hash;
    post.published = published;
    idToPost[postId] = post;
    hashToPost[hash] = post;
    emit PostUpdated(postId, title, hash, published);
  }

  /** fetch all posts */
  function fetchPosts() public view returns (Post[] memory) {
    uint itemCount = _postIds.current();

    Post[] memory posts = new Post[](itemCount);
    for (uint i = 0; i < itemCount; i++) {
      uint currentId = i + 1;
      Post storage currentItem = idToPost[currentId];
      posts[i] = currentItem;
    }
    return posts;
  }

}