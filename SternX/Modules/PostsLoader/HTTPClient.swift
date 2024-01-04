//Created for SternX in 2024
// Using Swift 5.0

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get (from url: URL, completion: @escaping (HTTPClientResult) -> Void) async throws
}

public class URLSessionHTTPClient: HTTPClient {
    
    private let session: URLSession
    
    public init(session: URLSession){
        self.session = session
    }
    
    public enum URLSessionAsyncErrors: Error {
        case invalidUrlResponse, missingResponseData
    }
    
    public func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) async throws {
        
        guard let url = URL( string:"https://jsonplaceholder.typicode.com/posts?limit=100" ) else {
            fatalError("Could not create URL object")
        }
        
        let req = URLRequest(url: url,timeoutInterval: 5)
                
        return try await withCheckedThrowingContinuation { continuation in
            session.dataTask(with: req ) { data , response , error in
                if error != nil {
                    continuation.resume(throwing: completion(.failure(URLSessionAsyncErrors.missingResponseData)) as! Error)
                    return
                }
                
                guard let data = data else {
                    continuation.resume(throwing: completion(.failure(URLSessionAsyncErrors.invalidUrlResponse)) as! Error)
                    return
                }
                continuation.resume(returning: completion(.success(data, response as! HTTPURLResponse)))
            }
            .resume()
        }
    }
}

