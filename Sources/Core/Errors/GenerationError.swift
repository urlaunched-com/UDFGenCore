//
//  ModuleGeneratorError.swift
//  UDFGen
//
//  Created by Eugene Ned on 31.01.2025.
//

import Foundation

public enum GenerationError: Error, CustomStringConvertible {
    case moduleExists(String)
    case invalidTemplateType(String)
    
    public var description: String {
        switch self {
        case .moduleExists(let message):
            return message
        case .invalidTemplateType(let message):
            return message
        }
    }
}
