//
//  URLSession_Imp.swift
//  CombineTesting
//
//  Created by macbook abdul on 26/01/2024.
//

import Foundation
import Combine

protocol HTTPClient {
   func get(url:URL) -> AnyPublisher<(Data,HTTPURLResponse),Error>
}
extension URLSession:HTTPClient{
   struct invalidHttpUrlResponse:Error{}

   func get(url: URL) -> AnyPublisher<(Data, HTTPURLResponse), Error> {
       dataTaskPublisher(for: url).tryMap { result in
           guard let httpResponse = result.response as? HTTPURLResponse else {
               throw invalidHttpUrlResponse()
           }
           return (result.data,httpResponse)
       }.eraseToAnyPublisher()
   }
   
}
