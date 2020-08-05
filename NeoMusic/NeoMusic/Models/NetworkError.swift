//
//  NetworkError.swift
//  NeoMusic
//
//  Created by Jordan Christensen on 7/21/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case encodingError
    case badResponse
    case otherError(Error)
    case noData
    case badDecode
    case noAuth
    case invalidInput
}

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}
