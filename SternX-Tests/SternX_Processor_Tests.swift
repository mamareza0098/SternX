//Created for SternX in 2024
// Using Swift 5.0

import XCTest


final class SternX_Processor_Tests: XCTestCase {

    func test_Processor_SetEmptyPosts() {
        
        let processor = makeSUT()
        XCTAssertTrue(processor.posts.isEmpty)
    }
    
    func test_Processor_SetPosts() {
        let posts = [Post(userId: 1, id: 141, title: "for test title", body: "Hello World")]
        let processor = makeSUT(posts: posts)
        XCTAssertEqual(processor.posts, posts)
    }
        
    func test_Processor_FillUsers() {
        let posts = [Post(userId: 1,id: 55, title: "No title", body: "Hello World"), Post(userId: 2,id: 56, title: "With title", body: "Goodbye World")]
        let processor = makeSUT(posts: posts)
        processor.fillUsers { users in
            XCTAssertEqual(users, Set([1, 2]))
        }
    }
    
    func test_Processor_FillUsersWithDuplicateID() {
        let posts = [Post(userId: 1,id: 55, title: "No title", body: "Hello World"), Post(userId: 2,id: 56, title: "With title", body: "Goodbye World"),Post(userId: 2,id: 57, title: "No title 2", body: "Hello World")]
        let processor = makeSUT(posts: posts)
        processor.fillUsers { users in
            XCTAssertEqual(users, Set([1, 2]))
        }
    }
    
    func test_Processor_GetTopFiveUsers() {
        let posts = [Post(userId: 1,id: 55, title: "No title", body: "Hello World"),
                     Post(userId: 1,id: 56, title: "No title", body: "Goodbye World"),
                     Post(userId: 1,id: 57, title: "No title", body: "Testing"),
                     Post(userId: 2,id: 58, title: "No title", body: "Hello World"),
                     Post(userId: 2,id: 59, title: "No title", body: "Goodbye World"),
                     Post(userId: 2,id: 60, title: "No title", body: "Testing"),
                     Post(userId: 3,id: 61, title: "No title", body: "Hello World"),
                     Post(userId: 3,id: 62, title: "No title", body: "Goodbye World"),
                     Post(userId: 4,id: 63, title: "No title", body: "Testing"),
        ]
        let processor = makeSUT(posts: posts)
        processor.getTopFiveUsers(top: 3) { topUsers in
            XCTAssertEqual(topUsers, [1, 2, 3])
        }
    }
    
    func test_Processor_FindAverageCharacterLengthOfBodyForEachUser() {
        let posts = [Post(userId: 1,id: 55, title: "No title", body: "Hello World123"),
                     Post(userId: 1,id: 56, title: "No title", body: "Goodbye World987"),
                     Post(userId: 1,id: 57, title: "No title", body: "Testing331"),
                     Post(userId: 2,id: 58, title: "No title", body: "Hello WorldHello World"),
                     Post(userId: 2,id: 59, title: "No title", body: "Goodbye WorldHello World"),
                     Post(userId: 2,id: 60, title: "No title", body: "Testing"),
                     Post(userId: 3,id: 61, title: "No title", body: "Hello World"),
                     Post(userId: 3,id: 62, title: "No title", body: "Goodbye World"),
                     Post(userId: 4,id: 63, title: "No title", body: "Testing"),
        ]
        let processor = makeSUT(posts: posts)
        processor.findAverageCharacterLengthOfBodyForEachUser(top: 3) { averages in
            XCTAssertEqual(averages, [1: 13, 2: 17, 3: 12])
        }
    }

    //Helper Functions
    func makeSUT(posts: [Post] = []) -> DataProcessor {
        let processor = DataProcessor()
        processor.setPosts(posts: posts)

        return processor
    }
    
    
    
}
