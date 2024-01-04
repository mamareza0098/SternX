//Created for SternX in 2024
// Using Swift 5.0

import Foundation


public final class PostLoader {
    private let client: HTTPClient
    private let url : URL
    
    public enum Result : Equatable{
        case success([Post])
        case failure(PostLoaderError)
    }
    
    
    public enum PostLoaderError : Swift.Error {
        case connectivity
        case invalidData
    }
    
    public init(url: URL , client: HTTPClient){
        self.url = url
        self.client = client
    }
    
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
    
    private func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let posts = try PostsMapper.map(data, response)
            return .success(posts)
        }catch {
            return .failure(.invalidData)
        }
    }
}

extension Task where Failure == Error {
    /// Performs an async task in a sync context.
    ///
    /// - Note: This function blocks the thread until the given operation is finished. The caller is responsible for managing multithreading.
    static func synchronous(priority: TaskPriority? = nil, operation: @escaping @Sendable () async throws -> Success) {
        let semaphore = DispatchSemaphore(value: 0)

        Task(priority: priority) {
            defer { semaphore.signal() }
            return try await operation()
        }

        semaphore.wait()
    }
}
