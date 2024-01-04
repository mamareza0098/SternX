//Created for SternX in 2024
// Using Swift 5.0

import Foundation

class DataProcessor {
    
    var posts: [Post] = []
    
    func setPosts(posts: [Post]) {
        self.posts = posts
    }
    
    func fillUsers(completion: (Set<Int>) -> Void) {
        let users : Set<Int> = Set(posts.map { $0.userId })
        completion(users)
    }

    func getTopFiveUsers(top count: Int, completion: @escaping ([Int]) -> Void) {
        fillUsers { users in
            let topUsers = users.map { user in
                let userPosts = posts.filter { $0.userId == user }
                return (user, userPosts.count)
            }
            let sortedTopUsers = topUsers.sorted { $0.1 > $1.1 }
            let topFiveUsers = sortedTopUsers.prefix(count).map { $0.0 }.sorted()
            completion(topFiveUsers)
        }
    }
    
    func findAverageCharacterLengthOfBodyForEachUser(top count: Int, completion: @escaping ([Int: Int]) -> Void) {
        getTopFiveUsers(top: count) { topUsers in
            let filteredPosts = self.posts.filter { topUsers.contains($0.userId) }
            let groupedPosts = Dictionary(grouping: filteredPosts) { $0.userId }
            let averages = groupedPosts.mapValues { posts in
                let lengths = posts.lazy.map { $0.body.count }
                return lengths.reduce(0, +) / (lengths.count)
            }
            completion(averages)
        }
    }
}
