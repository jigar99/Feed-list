//
//  FeedItem.swift
//  FeedTests
//
//  Created by Jigar on 8/9/24.
//

import Foundation


public struct FeedItem : Equatable {
    public let id: UUID
    public let imageURL : URL
    
    public init(id: UUID, imageURL: URL) {
        self.id = id
        self.imageURL = imageURL
    }
}

extension FeedItem: Decodable {
    private enum CodingKeys : String, CodingKey {
        case id
        case imageURL = "image"
    }
}
