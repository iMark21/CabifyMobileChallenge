//
//  CabifyClient.swift
//  CabifyMobileChallenge
//
//  Created by Juan Miguel Marqués Morilla on 18/05/2019.
//  Copyright © 2019 Míchel Marqués Morilla. All rights reserved.
//

import Foundation
import RxSwift

class APIClient {
    func send<T: Codable>(apiRequest: APIRequest) -> Observable<T> {
        return Observable<T>.create { observer in
            let request = apiRequest.request(with: URL(string: NetworkConstants.baseUrl)!)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                do {
                    let model: T = try JSONDecoder().decode(T.self, from: data ?? Data())
                    observer.onNext(model)
                } catch let error {
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
