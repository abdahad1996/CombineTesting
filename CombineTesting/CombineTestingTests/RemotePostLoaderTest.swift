//
//  RemotePostLoaderTest.swift
//  CombineTestingTests
//
//  Created by macbook abdul on 28/01/2024.
//

import Foundation
import XCTest
import CombineTesting
import Combine

final class RemotePostsLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestData(){
            let (_,client) = makeSut()
    
    
            XCTAssertEqual(client.requestCount, 0)
        }
    
    func test_get_RequestsData(){
            let (sut,client) = makeSut()
    
           let _ = sut.fetchPosts(url: anyURL())
    
            XCTAssertEqual(client.requestCount, 1)
        }
    
    func test_getTwice_RequestsDataTwice(){
        let (sut,client) = makeSut()


        let _ = sut.fetchPosts(url: anyURL())
        let _ = sut.fetchPosts(url: anyURL())


        XCTAssertEqual(client.requestCount, 2)
    }
    
    func test_load_DeliversErrorOnClientError(){
        let (sut,client) = makeSut()
        
        
        let cancellable = sut.fetchPosts(url: anyURL()).sink { completion in
            if case  .failure(let error) = completion {
                XCTAssertEqual(error as! GenericMapper.RemoteError, .connectivity)
            }else{
                XCTFail("expected to fail but passed")

            }
        } receiveValue: { _ in
            XCTFail("expected to fail but passed")
        }



        
        client.complete(with: anyNSError())
        
        
 //        expect(sut: sut, expectedResult: .failure(RemoteTransactionLoader.Error.connectivity)) {
//            let clientError = NSError(domain: "Test", code: 0)
//            client.complete(with: clientError)
//        }
        
    }
    
    
    func test_load_DeliversErrorOnNon200Error(){
        let (sut,client) = makeSut()
        let publisherSpy = PublisherSpy( sut.fetchPosts(url: anyURL()))

        
        client.complete(with: anyData(), response: HTTPURLResponse(url: anyURL(), statusCode: 199, httpVersion: nil, headerFields: nil)!)
        
        XCTAssertEqual(publisherSpy.error() as! GenericMapper.RemoteError, GenericMapper.RemoteError.connectivity)
        
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON(){
        let (sut,client) = makeSut()
        let publisherSpy = PublisherSpy( sut.fetchPosts(url: anyURL()))

        client.complete(with: anyData(), response: HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!)
        
        XCTAssertEqual(publisherSpy.error() as! GenericMapper.RemoteError, GenericMapper.RemoteError.invalidData)
        
    }
    
    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() {
        let (sut,client) = makeSut()
        let publisherSpy = PublisherSpy( sut.fetchPosts(url: anyURL()))

        
        client.complete(with: makeEmptyPost(), response: HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!)
        
        XCTAssertEqual(publisherSpy.value(),[])
        
    }
    
    func test_load_deliversItemsOn200HTTPResponseWithJSONItems() {
        let (sut,client) = makeSut()
        let publisherSpy = PublisherSpy( sut.fetchPosts(url: anyURL()))

        let posts = [Post(id: 1, title: "post 1"),Post(id: 2, title: "post 2"),Post(id: 3, title: "post 3")]
        client.complete(with: makePosts(posts: posts), response: HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!)
        
        XCTAssertEqual(publisherSpy.value(),posts)
        
        
    }
    
    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let client = HttpClientSpy()
        
       
        
        var sut: RemotePostsLoader? = RemotePostsLoader(session: client)

        let publisherSpy = PublisherSpy( sut!.fetchPosts(url: anyURL()))
        
        sut = nil
        publisherSpy.cancel()
        
        let posts = [Post(id: 1, title: "post 1"),Post(id: 2, title: "post 2"),Post(id: 3, title: "post 3")]
        client.complete(with: makePosts(posts: posts), response: HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!)
        
        XCTAssertEqual(publisherSpy.successResults,[])

    }
    
    private func makeSut(file: StaticString = #file, line: UInt = #line) -> (RemotePostsLoader,HttpClientSpy) {
            let client = HttpClientSpy()
            let sut = RemotePostsLoader(session: client)
            trackForMemoryLeaks(sut, file: file, line: line)
            trackForMemoryLeaks(client, file: file, line: line)
            return (sut,client)
        }
    
        func anyNSError() -> NSError {
            return NSError(domain: "any error", code: 0)
        }
    
        func anyURL(_ appendPath:String = "") -> URL {
            return URL(string: "http://any-url.com/\(appendPath)")!
        }
    
        func anyData() -> Data {
            return Data("any data".utf8)
        }
                    
        func makePosts(posts:[Post]) -> Data {
            let encoded = try! JSONEncoder().encode(posts)
    
           return  encoded
       }
    
    
        func makeEmptyPost() -> Data {
            let posts: [Post] = []
            let encoded = try! JSONEncoder().encode(posts)

           return  encoded
        }
    
}

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
//spyies on any publisher and stores messages in a result
final class PublisherSpy<Success> where Success: Equatable {
    private var cancellable: Cancellable?
    typealias error = Error
    private(set) var successResults = [Success]()
    private(set) var errorResults = [error]()

    init(_ publisher: AnyPublisher<Success, error>) {
        cancellable = publisher
            .sink(receiveCompletion: {[weak self] Completion in
            if case .failure(let error) = Completion {
                self?.errorResults.append(error)
            }
           
        }, receiveValue: {[weak self] value in
            self?.successResults.append(value)
        })
        
        
    }
    
    func value(at index: Int = 0) -> Success {
        return successResults[index]
    }

    func error(at index: Int = 0) -> error {
        return errorResults[index]
    }

    func cancel() {
        cancellable?.cancel()
    }
}


    public class HttpClientSpy:HTTPClient {
            var httpResult = [PassthroughSubject<(Data,HTTPURLResponse),Error>]()
    
            var requestCount:Int{
                httpResult.count
            }
    
            public func get(url: URL) -> AnyPublisher<(Data, HTTPURLResponse), Error> {
                let publisher = PassthroughSubject<(Data, HTTPURLResponse), Error>()
                httpResult.append(publisher)
                return publisher.eraseToAnyPublisher()
            }
    
            func complete(at index: Int = 0 ,with data:Data,response:HTTPURLResponse){
                httpResult[index].send((data,response))
                httpResult[index].send(completion: .finished)
    
            }
    
            func complete(at index: Int = 0,with error:Error){
                httpResult[index].send(completion: .failure(error))
            }
    
        }
