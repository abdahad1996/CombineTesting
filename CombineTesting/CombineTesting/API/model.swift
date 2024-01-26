//
//  model.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 26/01/2024.
//

import Foundation

public struct Post: Decodable {
    let id: Int
    let title: String
}

public struct PostDetail: Decodable,Equatable {
    let title: String
}

public struct Comment:Decodable,Equatable{
    let body:String
}
