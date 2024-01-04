//Created for SternX in 2024
// Using Swift 5.0

import Foundation
//import ArgumentParser

@main
struct CLI  {
    static func main() async throws {
//        for argument in CommandLine.arguments {
//            print(argument)
//        }
        
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts?limit=100")!
        let client = URLSessionHTTPClient(session: URLSession(configuration: .default))
        let postLoader = PostLoader(url: url, client: client)
        let processor = DataProcessor()
        let reporter = ReportGenerator()
        
        postLoader.load { res in
            switch res {
            case .success(let data):
                processor.setPosts(posts: data)
                processor.findAverageCharacterLengthOfBodyForEachUser(top: 5) { result in
                    reporter.generateReport(result)
                }
            case .failure(_):
                print("failed")
            }
        }
    }
}
