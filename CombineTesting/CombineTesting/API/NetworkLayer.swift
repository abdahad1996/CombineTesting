//
//  NetworkLayer.swift
//  CombineTesting
//
//  Created by macbook abdul on 26/01/2024.
//

import Foundation
import Combine


protocol PostsLoader {
    func fetchPosts(url:URL) -> AnyPublisher<[Post],Error>
}

protocol PostDetailsLoader {
    func fetchPostDetails(url:URL) -> AnyPublisher<PostDetail,Error>
}

protocol CommentsLoader {
    func fetchComments(posts:[Post]) -> AnyPublisher<[Comment],Error>
}

protocol ZipLoader {
    func fetchData(url:URL) -> AnyPublisher<(PostDetail,[Comment]),Error>
}
        

////mapping logic may change dependening on status code so i like to encapuslate the logic here
//class GenericApiMapper{
//    static func map<T>(data:Data,response:HTTPURLResponse) throws -> T where T:Decodable{
//        if (200..<300) ~= response.statusCode {
//            return try customDateJSONDecoder.decode(T.self, from: data)
//        }
//        if response.statusCode == 401 {
//            throw APIErrorHandler.tokenExpired
//        }
//        
//        if let error = try? JSONDecoder().decode(ApiErrorDTO.self, from: data) {
//            throw APIErrorHandler.customApiError(error)
//        } else {
//            throw APIErrorHandler.emptyErrorWithStatusCode(response.statusCode.description)
//        }
//        
//    }
//}


public class RemoteZipLoader:ZipLoader,PostsLoader {
    
    let session:HTTPClient
    
    public enum error:Error {
        case connectivity
        case invalidData
    }
    init(session: HTTPClient) {
        self.session = session
    }
   
    func fetchData(url: URL) -> AnyPublisher<(PostDetail, [Comment]), Error> {
       return fetchPosts(url: url).flatMap {(posts) -> AnyPublisher<(PostDetail, [Comment]), Error> in
            let post = posts.first!
            let postDetailUrl = Endpoint.postDetail(post: post).url(baseURL: url)
            let commentUrl = Endpoint.Comments(post: post).url(baseURL: url)

           return Publishers.Zip(
            self.fetchPostDetails(url: postDetailUrl),
            self.fetchComments(url: commentUrl)
           ).eraseToAnyPublisher()
               
        }.eraseToAnyPublisher()
       
    }
    
    func fetchPosts(url: URL) -> AnyPublisher<[Post], Error> {
        return session.get(url: url).tryMap(GenericMap).eraseToAnyPublisher()
    }
    
    func fetchComments(url: URL) -> AnyPublisher<[Comment],Error>{
        return session.get(url: url).tryMap(GenericMap).eraseToAnyPublisher()
    }

    func fetchPostDetails(url:URL) -> AnyPublisher<PostDetail,Error>{
        return session.get(url: url).tryMap(GenericMap).eraseToAnyPublisher()

    }

    
    func GenericMap<T>(data:Data,response:HTTPURLResponse) throws -> T where T:Decodable {
        guard response.statusCode == 200 else {
            throw error.connectivity
        }
               
        guard let decodable: T = try? JSONDecoder().decode(T.self, from: data) else {
            throw error.invalidData
        }
        
        return decodable
        
    }
    
    
    
}

