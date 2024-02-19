//
//  CombineTestingTests.swift
//  CombineTestingTests
//
//  Created by macbook abdul on 26/01/2024.
//

import XCTest
import Combine
import CombineTesting

//final class CombineTestingTests: XCTestCase {
//
//    func test_init_doesNotRequestData(){
//        let (_,client,_,_,_) = makeSut()
//
//        
//        XCTAssertEqual(client.requestCount, 0)
//    }
//    
//    func test_get_RequestsData(){
//        let (sut,client,_,_,_) = makeSut()
//
//        
//       let _ = sut.fetchData(url: anyURL())
//        
//        XCTAssertEqual(client.requestCount, 1)
//    }
//    
//    func test_getTwice_RequestsDataTwice(){
//        let (sut,client,_,_,_) = makeSut()
//
//        
//        let _ = sut.fetchData(url: anyURL())
//        let _ = sut.fetchData(url: anyURL())
//
//        
//        XCTAssertEqual(client.requestCount, 2)
//    }
//    
//    
//    func test_get_DeliversErrorOnClientError(){
//        let (sut,client,_,_,_) = makeSut()
//        let error = anyNSError()
//
//        
////        let cancellable = sut.fetchData(url: anyURL()).sink { completion in
////            if case .failure(let error) = completion{
////                XCTAssertEqual(error as! RemoteZipLoader.RemoteZipLoaderError, .connectivity)
////            }else{
////                XCTFail("expected to fail with completion but passed instead")
////
////            }
////        } receiveValue: { _ in
////            XCTFail("expected to fail but passed instead")
////
////        }
//
//        client.complete(at: anyURL(), with: anyNSError())
//        
//    }
//   
//    func test_load_DeliversErrorOnNon200Error(){
//        let (sut,client,_,_,_) = makeSut()
//        let error = anyNSError()
//
//        
//        let cancellable = sut.fetchData(url: anyURL()).sink { completion in
//            if case .failure(let error) = completion{
//                XCTAssertEqual(error as! RemoteZipLoader., .connectivity)
//            }else{
//                XCTFail("expected to fail with completion but passed instead")
//
//            }
//        } receiveValue: { _ in
//            XCTFail("expected to fail but passed instead")
//
//        }
//
//        client.complete(with: anyData(), response: HTTPURLResponse(url: anyURL(), statusCode: 199, httpVersion: nil, headerFields: nil)!)
//        
//    }
//    
//    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON(){
//        let (sut,client,publisher1,_,_) = makeSut()
//
//       let cancellable1 = publisher1.fetchPosts(url: anyURL("post"))
//        
//        
////        let cancellable = sut.fetchData(url: anyURL("")).sink { completion in
////            if case .failure(let error) = completion{
////                XCTAssertEqual(error as! RemoteZipLoader.RemoteZipLoaderError, .invalidData)
////            }else{
////                XCTFail("expected to fail with completion but passed instead")
////
////            }
////        } receiveValue: { _ in
////            XCTFail("expected to fail but passed instead")
////
////        }
//
//        client.complete(at: <#T##URL#>, with: <#T##Error#>)
//        client.complete(with: Data("invalid".utf8), response: HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!)
//        
//    }
//    
////    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJSONList(){
////        let (sut,client) = makeSut()
//////       let fetchPostsSpy = PublisherSpy(sut.fetchPosts(url: anyURL()))
////            
////        
////        let fetchPostDetails = PublisherSpy(sut.fetchPostDetails(url: anyURL()))
////        
////        let fetchComments = PublisherSpy(sut.fetchComments(url: anyURL()))
////        fetchPostDetails.complete(with: PostDetail(title: "hello"))
////        fetchComments.complete(with: [
////                            Comment(body: "test1"),
////                            Comment(body: "test2"),
////                            Comment(body: "test3")
////                        ])
////        
////        let cancellable = sut.fetchData(url: anyURL()).sink { completion in
////            if case .failure(let error) = completion{
////                XCTAssertEqual(error as! RemoteZipLoader.RemoteZipLoaderError, .invalidData)
////            }else{
////                XCTFail("expected to fail with completion but passed instead")
////
////            }
////        } receiveValue: { _ in
////            XCTFail("expected to fail but passed instead")
////
////        }
////
//////       let posts =  makePosts(id: 1, title: "sunt aut facere repellat provident occaecati excepturi optio reprehenderit")
//////        let posts =  makePosts(id: 1, title: "sunt aut facere repellat provident occaecati excepturi optio reprehenderit")
//////        let postDetail =  makePostDetail(title: "sunt aut facere repellat provident occaecati excepturi optio reprehenderit")
//////        makePostDetail
//////        client.complete(with: posts, response: HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!)
//////        client.complete(with: posts, response: HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!)
//////        client.complete(with: posts, response: HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!)
////        
////
////        
////    }
//
//    func makeItemsJSON(_ items: [[String: Any]]) -> Data {
//       let json = ["": items]
//       return try! JSONSerialization.data(withJSONObject: json)
//   }
//    
//    func makePostDetail(title:String) -> Data  {
//        let item = PostDetail(title: title)
//        let encoded = try! JSONEncoder().encode(item)
//
//        return encoded
//    }
//    func makePosts(id:Int,title:String) -> Data {
//       
//        let item = Post(id: id, title: title)
//        let encoded = try! JSONEncoder().encode([item])
//       
//       return  encoded
//   }
//    
//    
//    private func makeSut() -> (RemoteZipLoader,HttpClientSpy,RemotePostsLoader,RemotePostDetailsLoader,RemoteCommentsLoader) {
//        let client = HttpClientSpy()
//        let publisher1 = RemotePostsLoader(session:client)
//        let publisher2 = RemotePostDetailsLoader(session:client)
//        let publisher3 = RemoteCommentsLoader(session:client)
//
//        let sut = RemoteZipLoader(session: client,publisher1: publisher1,publisher2: publisher2,publisher3: publisher3)
//        return (sut,client,publisher1,publisher2,publisher3)
//    }
//    
//    func anyNSError() -> NSError {
//        return NSError(domain: "any error", code: 0)
//    }
//
//    func anyURL(_ appendPath:String = "") -> URL {
//        return URL(string: "http://any-url.com/\(appendPath)")!
//    }
//
//    func anyData() -> Data {
//        return Data("any data".utf8)
//    }
//
////    class RemoteZipLoaderSpy:ZipLoader{
////        var result = [PassthroughSubject<(PostDetail, [Comment]),Error>]()
////
////        func fetchData(url: URL) -> AnyPublisher<(PostDetail, [Comment]), Error> {
////            let publisher = PassthroughSubject<(PostDetail, [Comment]),Error>()
////            result.append(publisher)
////            return publisher.eraseToAnyPublisher()
////            
//////            let postDeatail = PostDetail(title: "post1")
//////            let comments = [
//////                Comment(body: "test1"),
//////                Comment(body: "test2"),
//////                Comment(body: "test3")
//////
//////
//////            ]
//////            return Just((postDeatail,comments)).setFailureType(to: Error.self).eraseToAnyPublisher()
////        }
////        
////        
////        func complete(at index: Int = 0 ,with postDetail:PostDetail,comments:[Comment]){
////            result[index].send((postDetail,comments))
////            result[index].send(completion: .finished)
////
////        }
////        
////        func complete(at index: Int = 0 ,with error:Error){
////            result[index].send(completion: .failure(error))
////        }
//        
////    }
//    public class HttpClientSpy:HTTPClient {
//        var httpResult = [URL:PassthroughSubject<(Data,HTTPURLResponse),Error>]()
//
//        var requestCount:Int{
//            httpResult.count
//        }
//        
//        public func get(url: URL) -> AnyPublisher<(Data, HTTPURLResponse), Error> {
//            let publisher = PassthroughSubject<(Data, HTTPURLResponse), Error>()
//            httpResult[url] = publisher
//            return publisher.eraseToAnyPublisher()
//        }
//        
//        func complete(at url: URL ,with data:Data,response:HTTPURLResponse){
//            httpResult[url]!.send((data,response))
//            httpResult[url]!.send(completion: .finished)
//
//        }
//        
//        func complete(at url: URL  ,with error:Error){
//            httpResult[url]!.send(completion: .failure(error))
//        }
//        
//    }
//    
//    final class PublisherSpy<T> where T: Decodable {
//        private(set) var results = [PassthroughSubject<T, Error>]()
//
//        init(_ publisher: AnyPublisher<T, Error>) {
//            let publisher = PassthroughSubject<T, Error>()
//            results.append(publisher)
////            return publisher.eraseToAnyPublisher()
//
//        }
//
//        func complete(at index: Int = 0 ,with model:T){
//            results[index].send(model)
//            results[index].send(completion: .finished)
//
//        }
//        
//        func complete(at index: Int = 0 ,with error:Error){
//            results[index].send(completion: .failure(error))
//        }
//        
//    }
//}
