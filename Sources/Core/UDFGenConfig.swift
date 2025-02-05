//
//  UDFGenConfig.swift
//  UDFGen
//
//  Created by Eugene Ned on 31.01.2025.
//

import Foundation

public struct UDFGenConfig: Codable {
    public let modulePath: String
    public let storagePath: String
    public let defaultModuleName: String?
    
    public static func load(from basePath: URL) throws -> UDFGenConfig {
        let configURL = try findConfigFile(startingAt: basePath)
        let data = try Data(contentsOf: configURL)
        let decoder = JSONDecoder()
        return try decoder.decode(UDFGenConfig.self, from: data)
    }
    
    private static func findConfigFile(startingAt path: URL) throws -> URL {
        var currentPath = path
        
        while true {
            let potentialConfig = currentPath.appendingPathComponent("udfgen.json")
            if FileManager.default.fileExists(atPath: potentialConfig.path) {
                return potentialConfig
            }
            
            // Move up one directory
            let parent = currentPath.deletingLastPathComponent()
            if parent == currentPath {
                break // Reached root directory
            }
            currentPath = parent
        }
        
        throw ConfigError.fileNotFound("Configuration file 'udfgen.json' not found in project.")
    }
}
