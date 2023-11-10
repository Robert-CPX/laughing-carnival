import { expect } from "chai";
import { ethers } from "hardhat";

describe('Blog', async () => {
  it('should create a post', async () => {
    const Blog = await ethers.getContractFactory('Blog');
    const blog = await Blog.deploy("my blog");
    await blog.deployed();
    await blog.createPost("my first post", "this is my first post");

    const posts = await blog.fetchPosts();
    expect(posts[0].title).to.equal("my first post");
  })

  it("Should edit a post", async () => {
    const Blog = await ethers.getContractFactory("Blog")
    const blog = await Blog.deploy("My blog")
    await blog.deployed()
    await blog.createPost("My Second post", "12345")

    await blog.updatePost(1, "My updated post", "23456", true)

    const posts = await blog.fetchPosts()
    expect(posts[0].title).to.equal("My updated post")
  })

  it("Should add update the name", async () => {
    const Blog = await ethers.getContractFactory("Blog")
    const blog = await Blog.deploy("My blog")
    await blog.deployed()

    expect(await blog.name()).to.equal("My blog")
    await blog.updateName('My new blog')
    expect(await blog.name()).to.equal("My new blog")
  })
});