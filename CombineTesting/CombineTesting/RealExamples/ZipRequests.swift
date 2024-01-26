//
//  ZipRequests.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 26/01/2024.
//

import Foundation
import SwiftUI
import Combine

class ZipViewModel:ObservableObject{
    let remoteZipLoader:ZipLoader
    var cancellable = Set<AnyCancellable>()
    @Published var chainedViewState: State = .idle
    
    public enum State:Equatable {
        case idle
        case isLoading
        case success(comments:[Comment],title:String)
        case failure
    }
    
    init(remoteZipLoader:ZipLoader) {
        chainedViewState = .isLoading
        self.remoteZipLoader = remoteZipLoader
        
        remoteZipLoader.fetchData(url: Endpoint.post.url(baseURL: URL(string:"https://jsonplaceholder.typicode.com/posts")!))
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.chainedViewState = .failure

                }
            }, receiveValue: { [weak self] (PostDetail, Comments) in
                self?.chainedViewState = .success(comments: Comments, title: PostDetail.title)
            })
            .store(in: &cancellable)
        
    }
    
    
}


struct ZipViewView:View {
    @StateObject var vm: ZipViewModel
    
    init(vm: ZipViewModel) {
        self._vm = StateObject(wrappedValue: vm)
    }
    var body: some View {
        VStack{
            switch vm.chainedViewState {
            case .isLoading:
                ProgressView()
            case .failure:
                Text("failure").foregroundStyle(.red)
            case .idle:
                Text("Nothing to do")
            case .success(let comments,let title):
                Text(title).foregroundStyle(.green).font(.largeTitle)
                
                List(comments, id: \.body) { comment in
                    Text(comment.body).font(.title2)
                }
            }
            
        }
    }
}


#Preview {
    ZipViewView(vm: ZipViewModel(remoteZipLoader: RemoteZipLoaderStub()))
}

class RemoteZipLoaderStub:ZipLoader{
    func fetchData(url: URL) -> AnyPublisher<(PostDetail, [Comment]), Error> {
        let postDeatail = PostDetail(title: "post1")
        let comments = [
            Comment(body: "test1"),
            Comment(body: "test2"),
            Comment(body: "test3")


        ]
        return Just((postDeatail,comments)).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    
}
