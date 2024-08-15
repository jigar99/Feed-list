//
//  FeedLoader.swift
//  Feed
//
//  Created by Jigar on 8/9/24.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case error(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
