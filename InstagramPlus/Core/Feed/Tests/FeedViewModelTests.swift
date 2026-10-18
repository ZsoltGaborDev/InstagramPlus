//
//  FeedViewModelTests.swift
//  InstagramPlusTests
//
//  Created by Zsolt Gabor on 16/10/2026.
//

import XCTest
@testable import InstagramPlus

@MainActor
final class FeedViewModelTests: XCTestCase {
    var viewModel: FeedViewModel!
    var mockFeedService: MockFeedService!
    var mockLikeService: MockLikePostService!
    var mockSavedPostService: MockSavedPostsService!
    var mockUserService: MockUserService!
    
    override func setUp() {
        super.setUp()
        mockLikeService = MockLikePostService()
        mockSavedPostService = MockSavedPostsService()
        
        mockFeedService = MockFeedService(likePostService: mockLikeService, savedPostsService: mockSavedPostService)
        mockUserService = MockUserService()
        
        viewModel = FeedViewModel(feedService: mockFeedService, userService: mockUserService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockFeedService = nil
        mockLikeService = nil
        mockSavedPostService = nil
        mockUserService = nil
        
        super.tearDown()
    }
    
    func testFetchFeedPosts() async {
        await viewModel.fetchPosts()
        
        XCTAssertFalse(viewModel.posts.isEmpty)
        XCTAssertEqual(viewModel.loadingState, .complete)
        
        for post in viewModel.posts {
            XCTAssertNotNil(post.user)
        }
    }
    
    func testFetchedPostsHasUser() async {
        await viewModel.fetchPosts()
        
        for post in viewModel.posts {
            XCTAssertNotNil(post.user)
        }
    }
    
    func testFetchedPostsUserIsOwner() async {
        await viewModel.fetchPosts()
        
        for post in viewModel.posts {
            XCTAssertEqual(post.ownerUid, post.user?.id)
        }
    }
    
    func testRefreshPosts() async {
        let countBeforeRefresh = viewModel.posts.count
        
        await viewModel.refreshPosts()
        let countAfterRefresh = viewModel.posts.count
        
        XCTAssertEqual(countBeforeRefresh, countAfterRefresh)
    }
    
    func testLikePost() async {
        let postToLike = viewModel.posts[0]
        let likesCountBeforeLike = viewModel.posts[0].likes ?? 0
        await viewModel.like(postToLike)
        
        XCTAssertTrue(mockLikeService.didCallLikePost)
        XCTAssertTrue(viewModel.posts[0].didLike)
        XCTAssertEqual(viewModel.posts[0].likes, likesCountBeforeLike + 1)
    }
    
    func testUnlikePost() async {
        let postToLike = viewModel.posts[0]
        let likesCountBeforeLike = viewModel.posts[0].likes ?? 0
        await viewModel.like(postToLike)
        XCTAssertEqual(viewModel.posts[0].likes, likesCountBeforeLike + 1)
        
        await viewModel.unlike(postToLike)
        XCTAssertTrue(mockLikeService.didCallLikePost)
        XCTAssertFalse(viewModel.posts[0].didLike)
        XCTAssertEqual(viewModel.posts[0].likes, likesCountBeforeLike)
    }
    
    func testUnlikePostWithNoLikes() async {
        viewModel.posts[0].likes = 0
        let postToLike = viewModel.posts[0]
        await viewModel.unlike(postToLike)
        XCTAssertEqual(viewModel.posts[0].likes, 0)
        XCTAssertFalse(mockLikeService.didCallLikePost)
    }
    
    func testSavePost() async {
        let postToSave = viewModel.posts[0]
        await viewModel.save(postToSave)
        
        XCTAssertTrue(viewModel.posts[0].didSave)
        XCTAssertTrue(mockSavedPostService.savePostDidCalled)
    }
    
    func testUnsavePost() async {
        let postToUnsave = viewModel.posts[0]
        await viewModel.unsave(postToUnsave)
        
        XCTAssertFalse(viewModel.posts[0].didSave)
        XCTAssertTrue(mockSavedPostService.unsavePostDidCalled)
    }
}
