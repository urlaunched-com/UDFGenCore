//
//  Utilities.swift
//  UDFGen
//
//  Created by Eugene Ned on 31.01.2025.
//

import Foundation

public struct Utilities {
    
    /// Locates the project root by searching upwards from the given path for the configuration file.
    /// - Parameter packagePath: The starting path (usually the package directory).
    /// - Returns: The URL of the project root directory.
    /// - Throws: `PluginError.configurationError` if the configuration file is not found.
    public static func locateProjectRoot(from packageURL: URL) throws -> URL {
        var currentPackageURL: URL = packageURL
        while true {
            let potentialConfig = currentPackageURL.appendingPathComponent("udfgen.json")
            if FileManager.default.fileExists(atPath: potentialConfig.path) {
                return currentPackageURL
            }
            
            // Move up one directory
            let parentURL = currentPackageURL.deletingLastPathComponent()
            if parentURL == currentPackageURL {
                break // Reached root directory
            }
            currentPackageURL = parentURL
        }
        
        throw PluginError.configurationError("Configuration file 'udfgen.json' not found in project.")
    }
    
    /// Parses the module name based on the provided arguments and configuration.
    /// - Parameters:
    ///   - arguments: The command-line arguments passed to the plugin.
    ///   - config: The loaded configuration from `udfgen.json`.
    /// - Returns: The determined module name.
    public static func parseModuleName(arguments: [String], config: UDFGenConfig) -> String {
        // Priority: Positional Argument > --name Argument > Config Default > Hard-Coded Default
        if let firstArg = arguments.last, !firstArg.starts(with: "--") {
            return firstArg
        } else if let nameIndex = arguments.firstIndex(of: "--name"), arguments.count > nameIndex + 1 {
            return arguments[nameIndex + 1]
        } else if let defaultName = config.defaultModuleName {
            return defaultName
        } else {
            return "NewModule"
        }
    }
    
    /// Searches for a folder named "UDFGen" starting from the given directory.
    /// - Parameter startURL: The URL from which to begin the search.
    /// - Returns: The URL of the "UDFGen" folder if found; otherwise, `nil`.
    public static func findUDFGenFolder(startingAt startURL: URL) -> URL? {
        let fileManager = FileManager.default
        guard let enumerator = fileManager.enumerator(
            at: startURL,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: [.skipsHiddenFiles, .skipsPackageDescendants]
        ) else {
            return nil
        }
        
        for case let fileURL as URL in enumerator {
            if fileURL.lastPathComponent == "UDFGenTest" {
                var isDirectory: ObjCBool = false
                if fileManager.fileExists(atPath: fileURL.path, isDirectory: &isDirectory),
                   isDirectory.boolValue {
                    return fileURL
                }
            }
        }
        return nil
    }
}
