//
//  NetworkLayer.swift
//  CombineTesting
//
//  Created by macbook abdul on 26/01/2024.
//

import Foundation
import Combine


public protocol PostsLoader {
    func fetchPosts(url:URL) -> AnyPublisher<[Post],Error>
}

public protocol PostDetailsLoader {
    func fetchPostDetails(url:URL) -> AnyPublisher<PostDetail,Error>
}

public protocol CommentsLoader {
    func fetchComments(url: URL) -> AnyPublisher<[Comment],Error>
}

public protocol ZipLoader {
    func fetchData(url:URL) -> AnyPublisher<(PostDetail,[Comment]),Error>
}


public class RemoteCommentsLoader:CommentsLoader{
    let session:HTTPClient
    public init(session: HTTPClient) {
        self.session = session
    }
    public func fetchComments(url: URL) -> AnyPublisher<[Comment], Error> {
        return session.get(url: url)
            .mapError(GenericMapper.mapError)
            .tryMap(GenericMapper.GenericMap)
            .eraseToAnyPublisher()
        
    }
    
}
public class RemotePostDetailsLoader:PostDetailsLoader{
    let session:HTTPClient
    public init(session: HTTPClient) {
        self.session = session
    }
    public func fetchPostDetails(url: URL) -> AnyPublisher<PostDetail, Error> {
        return session.get(url: url)
            .mapError(GenericMapper.mapError)
            .tryMap(GenericMapper.GenericMap)
            .eraseToAnyPublisher()
        
    }
    
}
public class RemotePostsLoader:PostsLoader{
    
    let session:HTTPClient
    public init(session: HTTPClient) {
        self.session = session
    }
    public enum RemoteZipLoaderError:Error {
        case connectivity
        case invalidData
    }
    public func fetchPosts(url: URL) -> AnyPublisher<[Post], Error> {
        return session.get(url: url)
            .mapError(GenericMapper.mapError)
            .tryMap(GenericMapper.GenericMap)
            .eraseToAnyPublisher()
        
    }
    
}
public class RemoteZipLoader:ZipLoader{
    
    let session:HTTPClient
    let publisher1:PostsLoader
    let publisher2:PostDetailsLoader
    let publisher3:CommentsLoader

    
    public init(session: HTTPClient,publisher1:PostsLoader,publisher2:PostDetailsLoader,publisher3:CommentsLoader) {
        self.session = session
        self.publisher1 = publisher1
        self.publisher2 = publisher2
        self.publisher3 = publisher3
    }
    
    public func fetchData(url: URL) -> AnyPublisher<(PostDetail, [Comment]), Error> {
        return publisher1.fetchPosts(url: url)
            .flatMap {(posts) -> AnyPublisher<(PostDetail, [Comment]), Error> in
            let post = posts.first!
            let postDetailUrl = Endpoint.postDetail(post: post).url(baseURL: url)
            let commentUrl = Endpoint.Comments(post: post).url(baseURL: url)
            return Publishers.Zip(
                self.publisher2.fetchPostDetails(url: postDetailUrl),
                self.publisher3.fetchComments(url: commentUrl)
            ).eraseToAnyPublisher()
            
        }
        
        .eraseToAnyPublisher()
        
    }
    
    
    
    
    
}

public class GenericMapper {
    
    public enum RemoteError:Swift.Error {
        case connectivity
        case invalidData
    }
    
    static func mapError(error:Error) -> RemoteError{
            if let responseError = error as? RemoteError {
                return responseError
            }else{
                return RemoteError.connectivity
            }
        }
    
    
    

    
    static func GenericMap<T>(data:Data,response:HTTPURLResponse) throws -> T where T:Decodable {
        guard response.statusCode == 200 else {
            throw RemoteError.connectivity
        }
               
        guard let decodable: T = try? JSONDecoder().decode(T.self, from: data) else {
            throw RemoteError.invalidData
        }
        
        return decodable
        
    }
    
}
