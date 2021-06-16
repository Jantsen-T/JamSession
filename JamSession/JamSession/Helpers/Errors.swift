//
//  Errors.swift
//  JamSession
//
//  Created by Jantsen Tanner on 6/15/21.
//

import Foundation

enum UserError: LocalizedError {
    
    case invalidURL
    case thrownError(Error)
    case noData
    case unableToDecode
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Unable to reach the server."
        case .thrownError(let error):
            return "Something went wrong decoding the data. \(error)"
        case .noData:
            return "The server responded with no data."
        case .unableToDecode:
            return "Unable to decode the data."
        }
    }
    
}
