//Created for SternX in 2024
// Using Swift 5.0

import XCTest


class PostLoaderTests : XCTestCase {
    
    func test_init_doesNotRequestURLFromServer(){
        
        let (_,client) = makeSUT()
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_RequestDataFromURL(){
        
        let url = URL(string: "http://a-given-url.com")!
        let (sut,client) = makeSUT(url: url)
        
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs,[url])
    }
    
    func test_load_TwiceRequestDataFromURL(){
        
        let url = URL(string: "http://a-given-url.com")!
        let (sut,client) = makeSUT(url: url)
        
        sut.load { _ in }
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs,[url,url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut,client) = makeSUT()
        
        expect(sut, toCompleteWithResult: .failure(.connectivity)) {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        }
    }
    
    func test_load_deliversErrorOnNon200Response() {
        let (sut,client) = makeSUT()
        
        let samples = [199,201,300,400,500]
        samples.enumerated().forEach { index, code in
            
            expect(sut, toCompleteWithResult: .failure(.invalidData)) {
                let json = makeItemsJSON([])
                client.complete(withStatusCode: code, data: json,at: index)
            }
        }
    }
    
    func test_load_deliversErrorOn200ResponseInvalidJSON() {
        let (sut,client) = makeSUT()
        
        expect(sut, toCompleteWithResult: .failure(.invalidData)) {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200,data: invalidJSON)
        }
    }
    
    func test_load_deliversNoItemsOn200ResponseWithEmptyJSONList() {
        let (sut,client) = makeSUT()
        
        expect(sut, toCompleteWithResult: .success([])) {
            let emptyListJson = makeItemsJSON([])
            client.complete(withStatusCode: 200,data: emptyListJson)
        }
    }
    
    func test_load_deliversItemsOn200ResponseWithJSONItems() {
        let (sut,client) = makeSUT()
        
        let (post1, post1JSON) = makeItems(userId: 1, id: 1, title: nil, body: "This is a test body")
        let (post2, post2JSON) = makeItems(userId: 2, id: 4, title: "test2", body:  "this is another test body")
        
        let posts = [post1, post2]
        
        expect(sut, toCompleteWithResult: .success(posts)) {
            
            let json = makeItemsJSON([post1JSON,post2JSON])
            client.complete(withStatusCode: 200,data: json)
            
        }
    }
    
    //Tests Helper Funcitons
    private func makeSUT(url: URL =  URL(string: "http://a-given-url.com")!) -> (sut: PostLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = PostLoader(url: url, client: client)
        return (sut,client)
    }
    
    private func expect(_ sut: PostLoader , toCompleteWithResult result: PostLoader.Result,when action: () -> Void, file: StaticString  = #file, line: UInt = #line ) {
        var capturedResults = [PostLoader.Result]()
        sut.load { capturedResults.append($0) }
        
        action()
        
        XCTAssertEqual(capturedResults, [result], file: file, line: line)
    }
    
    private func makeItems(userId: Int, id: Int, title: String?, body: String) -> (model: Post, jsonModel: [String:Any]) {
        
        let post = Post(userId: userId, id: id, title: title , body: body)
        let postJSON = ["userId": post.userId, "id": post.id,"title": post.title, "body": post.body] as [String : Any]
        return (post, postJSON)
    }
    
    private func makeItemsJSON(_ items: [[String: Any]]) -> Data {
        let json = items
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    private class HTTPClientSpy: HTTPClient {
        var requestedURLs : [URL] {
            return messages.map { $0.url }
        }
        
        private var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()
        
        func get (from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url,completion))
        }
        
        func complete(with error: Error, at index: Int = 0){
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data, at index: Int = 0){
            let response = HTTPURLResponse(url: requestedURLs[index], statusCode: code, httpVersion: nil, headerFields: nil)
            messages[index].completion(.success(data, response!))
        }
    }
}
