//
//  EndPoint.swift
//  CombineTesting
//
//  Created by macbook abdul on 26/01/2024.
//

import Foundation

public enum Endpoint {
    case post
    case postDetail(post:Post)
    case Comments(post:Post)
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case .post:
            return baseURL
        case .postDetail(post: let post):
            return baseURL.appendingPathComponent("\(post.id)")
        case .Comments(post: let post):
            return baseURL.appendingPathComponent("\(post.id)/comments")
        }
    }
}
