//
//  TemplateManagerError.swift
//  UDFGen
//
//  Created by Eugene Ned on 31.01.2025.
//

import Foundation

public enum TemplateError: Error, CustomStringConvertible {
    case templateNotFound(String)
    
    public var description: String {
        switch self {
        case .templateNotFound(let message):
            return message
        }
    }
}
