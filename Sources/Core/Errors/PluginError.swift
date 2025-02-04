//
//  PluginError.swift
//  UDFGen
//
//  Created by Eugene Ned on 31.01.2025.
//

import Foundation

public enum PluginError: Error, CustomStringConvertible {
    case configurationError(String)
    case generationError(String)
    case templateError(String)
    
    public var description: String {
        switch self {
        case .configurationError(let message):
            return "Configuration Error: \(message)"
        case .generationError(let message):
            return "Generation Error: \(message)"
        case .templateError(let message):
            return "Template Error: \(message)"
        }
    }
}
