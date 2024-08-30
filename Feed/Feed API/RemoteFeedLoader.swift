//
//  RemoteFeedLoader.swift
//  Feed
//
//  Created by Jigar on 8/12/24.
//

import Foundation

public enum HTTPClientResult {
    case success(Data,HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {

    func get(from url: URL,completion : @escaping(HTTPClientResult) -> Void)
}

public final class RemoteFeedLoader {
    
   private var client: HTTPClient
   private let url: URL
    
    public init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public enum Results : Equatable {
        case success([FeedItem])
        case failure(Error)
    }
    
    public func load(completion: @escaping(Results) -> Void) {
        client.get(from: url) { result  in
            switch result {
            case let .success(data, response):
                if response.statusCode == 200,let  root = try? JSONDecoder().decode(Root.self, from: data) {
                    completion(.success(root.items))
                } else {
                    completion(.failure(.invalidData))
                }
                
            case .failure:
                completion(.failure(.connectivity))
            }
            
        }
    }
    
    private struct Root :Decodable {
        let items:[FeedItem]
    }
}
