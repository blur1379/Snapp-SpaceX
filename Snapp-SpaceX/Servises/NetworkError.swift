//
//  NetworkError.swift
//  Snapp-SpaceX
//
//  Created by Mohammad Blur on 8/10/23.
//

import Foundation
enum NetworkError : String, Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case invalidParameter
    case emptyResponse
}
