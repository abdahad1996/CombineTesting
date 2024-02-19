//
//  model.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 26/01/2024.
//

import Foundation

public struct Post: Codable,Equatable {
    let id: Int
    let title: String
    
    public init(id: Int, title: String) {
        self.id = id
        self.title = title
    }
}

public struct PostDetail: Codable,Equatable {
    let title: String
    public init(title: String) {
        self.title = title
    }
}

public struct Comment:Codable,Equatable{
    let body:String
    
    public init( body: String) {
        self.body = body
    }
}
