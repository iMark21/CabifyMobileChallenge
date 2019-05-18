//
//  CabifyRequest.swift
//  CabifyMobileChallenge
//
//  Created by Juan Miguel Marqués Morilla on 18/05/2019.
//  Copyright © 2019 Míchel Marqués Morilla. All rights reserved.
//

import Foundation

public enum RequestType: String {
    case GET, POST
}

protocol APIRequest {
    var method: RequestType { get }
    var endPoint: String { get set }
}

extension APIRequest {
    func request(with baseURL: URL) -> URLRequest {
        guard let components = URLComponents(url: baseURL.appendingPathComponent(endPoint), resolvingAgainstBaseURL: false) else {
            fatalError("Unable to create URL components")
        }
        
        guard let url = components.url else {
            fatalError("Could not get url")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}
