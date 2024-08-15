//
//  RemoteFeedLoaderTests.swift
//  FeedTests
//
//  Created by Jigar on 8/12/24.
//

import XCTest
import Feed

final class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        
        let (_,client) =  makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL()  {
        
        //Arrange
        let url  = URL(string: "https://a-given-url.com")!
        let (sut,client) = makeSUT(url: url)
        
        // Act
        sut.load()

        //Assert
        XCTAssertEqual(client.requestedURLs,[url])
    }
    
    func test_load_deliverysErrorOnClietnError() {
        let (sut,client) = makeSUT()
        expect(sut, toCompleteWith: .failure(.connectivity), when: {
            let clientError = NSError(domain: "Test",code: 0)
            client.complete(with: clientError)
        })
    }
    
    func test_load_deliverysErrorOnNon200HTTPResponse() {
        let (sut,client) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(.invalidData), when: {
            let clientError = NSError(domain: "Test",code: 0)
            client.complete(withStatusCode: 400)
        })
    }
    
    func test_load_deliverysErrorOnNon200HTTPResponseWithInvalidJson() {
        let (sut,client) = makeSUT()
        expect(sut, toCompleteWith: .failure(.invalidData), when: {
            var invalidJSON = Data(bytes: "invalid json".utf8)
            client.complete(withStatusCode: 200,data: invalidJSON)
        })
    }
    
    func test_load_deliverysErrorOnNon200HTTPResponseWithEmptyJsonList() {
        let (sut,client) = makeSUT()
        
        expect(sut, toCompleteWith: .success([])) {
            let emptyListJSON = Data(bytes: "{\"items\":[]}".utf8)
            client.complete(withStatusCode: 200,data: emptyListJSON)
        }
        
        
        
    }
    
    func test_load_deliverysErrorOnNon200HTTPResponseWithEmptyJsonItems() {
        let (sut,client) = makeSUT()
        let item1 = FeedItem(id: UUID(), imageURL: URL(string: "http://a-url.com")!)
        
        let item1Json = ["id": item1.id.uuidString,
                         "image" :item1.imageURL.absoluteString
         ]
        
        let itemsJson = ["items" :[item1Json]]
        
        expect(sut, toCompleteWith: .success([item1])) {
            let json = try! JSONSerialization.data(withJSONObject: itemsJson)
            client.complete(withStatusCode: 200,data:json)
        }
        
    }
    
    //Mark: - Helper
    
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) ->(sut: RemoteFeedLoader, client: HTTPClientSpy){
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(client: client, url: url)
        return(sut,client)
    }
    
    private func expect(_ sut:RemoteFeedLoader, toCompleteWith result : RemoteFeedLoader.Results, when action:() -> Void,file: StaticString = #file,line : UInt = #line) {
        
        var capturedError =  [RemoteFeedLoader.Results]()
        sut.load { error in
            capturedError.append(error)
        }
        action()

        XCTAssertEqual(capturedError, [result],file:file,line: line)
    }
    
    
    private  class HTTPClientSpy : HTTPClient {
       
        var requestedURLs  = [URL]()
        var error: Error?
       
        
        private var message  = [(url: URL, completion: (HTTPClientResult) -> Void)]()
        
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            requestedURLs.append(url)
            message.append((url,completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            message[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int,data:Data = Data(), at index: Int = 0) {
            let response = HTTPURLResponse(url: requestedURLs[index], statusCode: code, httpVersion: nil, headerFields: nil)!
            message[index].completion(.success(data,response))
        }
        
    }

}
