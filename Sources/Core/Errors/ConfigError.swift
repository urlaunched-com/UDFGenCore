//
//  ConfigError.swift
//  UDFGen
//
//  Created by Eugene Ned on 31.01.2025.
//

import Foundation

public enum ConfigError: Error, CustomStringConvertible {
    case fileNotFound(String)
    case decodingError(String)
    
    public var description: String {
        switch self {
        case .fileNotFound(let message):
            return message
        case .decodingError(let message):
            return message
        }
    }
}
