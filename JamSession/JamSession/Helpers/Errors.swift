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
enum ManErr: LocalizedError{
    case cannotlogin
    case noSuchUser
    case firebaseError(Error)
    case tooManySameUsername
}
enum FireError: LocalizedError{
    case NoData
    case IncorrectFormat
    case Fat(Error)
    case StringDecode
    var errorDescription: String?{
        switch self{
        case .NoData:
            return "no data"
        case .IncorrectFormat:
            return "format"
        case .Fat(let err):
            return err.localizedDescription
        case .StringDecode:
            return "string decode"
        }
    }
}
