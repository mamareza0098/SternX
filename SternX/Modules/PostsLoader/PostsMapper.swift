//Created for SternX in 2024
// Using Swift 5.0

import Foundation

// Maps the response data to an array of `PostBased on the provided code, here's an explanation of the comments/documentation:

internal final class PostsMapper {
    
    private struct PostItem: Decodable {
        let userId: Int
        let id: Int
        let title: String?
        let body: String
        
        var post: Post {
            return Post(userId: userId, id: id, title: title, body: body)
        }
    }
    
    internal static func map (_ data: Data,_ response: HTTPURLResponse) throws -> [Post] {
        guard response.statusCode == 200 else {
            throw PostLoader.PostLoaderError.invalidData
        }
        do {
            let root = try JSONDecoder().decode([PostItem].self, from: data)
            return root.map{ $0.post }
        }catch {
            print("Error decoding \(error)")
            throw error
        }
    }
}
