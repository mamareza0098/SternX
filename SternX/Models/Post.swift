//Created for SternX in 2024
// Using Swift 5.0

import Foundation

// Represents a post with the following properties:
// - userId: The ID of the user who created the post.
// - id: The ID of the post.
// - title: The title of the post (optional).
// - body: The body content of the post.

public struct Post: Hashable, Equatable {
    public let userId: Int
    public let id: Int
    public let title: String?
    public let body: String
    
    // Initializes a new instance of the `Post` struct.

    public init(userId: Int,id: Int, title: String?, body: String){
        self.userId = userId
        self.id = id
        self.title = title
        self.body = body
    }
}
