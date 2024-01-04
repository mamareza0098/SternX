//Created for SternX in 2024
// Using Swift 5.0

import Foundation


public final class PostLoader {
    private let client: HTTPClient
    private let url : URL
    
    // Represents the result of loading posts.
    // - success: Loading posts was successful, providing an array of `Post` objects.
    // - failure: Loading posts failed, providing a `PostLoaderError`.
    public enum Result : Equatable{
        case success([Post])
        case failure(PostLoaderError)
    }
    
    // Represents the possible errors that can occur during post loading.
    public enum PostLoaderError : Swift.Error {

        case connectivity
        case invalidData
    }
    
    // Initializes a new instance of the `PostLoader` class.
    public init(url: URL , client: HTTPClient){
        self.url = url
        self.client = client
    }
    
    // Loads posts asynchronously and calls the completion handler with the result.
    public func load(completion: @escaping (Result) -> Void) {
        
        Task.synchronous {
            do {
                try await self.client.get(from: self.url) { result in
                    switch result{
                    case let .success(data, response):
                        completion(self.map(data, from: response))
                    case .failure:
                        completion(.failure(.connectivity))
                        
                    }
                }
            }catch {
                print(error)
            }
        }
    }
    
    // Maps the response data to a `Result` type.
    private func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let posts = try PostsMapper.map(data, response)
            return .success(posts)
        }catch {
            return .failure(.invalidData)
        }
    }
}
