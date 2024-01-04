//Created for SternX in 2024
// Using Swift 5.0

import Foundation

public struct Post: Hashable, Equatable {
    public let userId: Int
    public let id: Int
    public let title: String?
    public let body: String
    
    public init(userId: Int,id: Int, title: String?, body: String){
        self.userId = userId
        self.id = id
        self.title = title
        self.body = body
    }
}
