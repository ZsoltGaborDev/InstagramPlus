//
//  CommentsViewModelTests.swift
//  InstagramPlusTests
//
//  Created by Zsolt Gabor on 07/10/2026.
//

import Foundation
import XCTest
@testable import InstagramPlus

@MainActor
final class CommentsViewModelTests: XCTestCase {
    private var viewModel: CommentViewModel!
    private var post: Post!
    private var mockCommentService: MockCommentService!
    private var mockUserService: UserServiceProtocol!
    private var currentUser: User!
    
    override func setUp() {
        super.setUp()
        
        self.post = MockData.posts[0]
        self.mockCommentService = MockCommentService(postId: post.id)
        self.mockUserService = MockUserService()
        self.currentUser = MockData.users[0]
        
        viewModel = CommentViewModel(
            post: post,
            commentService: mockCommentService,
            userService: mockUserService
        )
    }
    
    override func tearDown() {
        viewModel = nil
        mockCommentService = nil
        mockUserService = nil
        post = nil
        currentUser = nil
        
        super.tearDown()
    }
    
    func testFetchComments_Success() async {
        XCTAssertEqual(viewModel.loadingState, .loading)
        await viewModel.fetchComments()
        let commentUsers = viewModel.comments.map { $0.user }
        
        XCTAssertFalse(viewModel.comments.isEmpty)
        XCTAssertFalse(commentUsers.isEmpty)
        XCTAssertEqual(viewModel.loadingState, .complete)
    }
    
    func testFetchComments_Failure() async {
        mockCommentService.errorToThrow = NSError(domain: "", code: -1)
        
        await viewModel.fetchComments()
        XCTAssertTrue(viewModel.comments.isEmpty)
        XCTAssertEqual(viewModel.loadingState, .error)
    }
    
    func testEmptyState_Success() async {
        mockCommentService.shouldTestEmptyState = true

        await viewModel.fetchComments()

        XCTAssertEqual(viewModel.loadingState, .empty)
    }
    
    func testUploadComments_Success() async {
        let commentText = "New test comment"
        
        await viewModel.uploadComment(text: commentText, currentUser: currentUser)
        
        XCTAssertEqual(viewModel.comments.count, 1)
        XCTAssertEqual(viewModel.comments.first?.text, commentText)
        XCTAssertNotNil(viewModel.comments.first?.user)
        XCTAssertEqual(viewModel.comments.first?.user?.id, currentUser.id)
    }
    
    func testUploadComments_Failure() async {
        let commentText = "New test comment"
        mockCommentService.errorToThrow = NSError(domain: "", code: -1)
        
        await viewModel.uploadComment(text: commentText, currentUser: currentUser)
        
        XCTAssertTrue(viewModel.comments.isEmpty)
        XCTAssertEqual(viewModel.loadingState, .error)
    }
}
