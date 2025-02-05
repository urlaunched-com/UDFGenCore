//
//  ModuleGenerator.swift
//  UDFGen
//
//  Created by Eugene Ned on 31.01.2025.
//

import Foundation

public final class ModuleGenerator {
    private let config: UDFGenConfig
    private let moduleName: String
    private let templateType: TemplateType
    private let basePath: URL
    private let packagePath: URL
    
    public init(
        config: UDFGenConfig,
        moduleName: String,
        templateType: TemplateType,
        basePath: URL
    ) {
        self.config = config
        self.moduleName = moduleName
        self.templateType = templateType
        self.basePath = basePath
        self.packagePath = Utilities.findUDFGenFolder(startingAt: basePath) ?? basePath
    }
    
    public func generate() throws {
        let targetPath = basePath
            .appendingPathComponent(templateType == .storage ? config.storagePath : config.modulePath)
            .appendingPathComponent(moduleName)
        
        if FileManager.default.fileExists(atPath: targetPath.path) {
            throw GenerationError.moduleExists("Module '\(moduleName)' already exists at \(targetPath.path).")
        }
        
        try FileManager.default.createDirectory(at: targetPath, withIntermediateDirectories: true, attributes: nil)
        
        let templateManager = TemplateManager(packagePath: packagePath, templateType: templateType)
        let templates = try loadTemplates()
        
        for (relativePath, templateName) in templates {
            let renderedContent = try templateManager.renderTemplate(named: templateName, with: moduleName)
            let filePath = targetPath.appendingPathComponent(relativePath)
            let fileDirectory = filePath.deletingLastPathComponent()
            
            if !FileManager.default.fileExists(atPath: fileDirectory.path) {
                try FileManager.default.createDirectory(at: fileDirectory, withIntermediateDirectories: true, attributes: nil)
            }
            
            try renderedContent.write(to: filePath, atomically: false, encoding: .utf8)
        }
        
        print("Module '\(moduleName)' successfully generated at: \(targetPath.path)")
    }
    
    private func loadTemplates() throws -> [String: String] {
        switch templateType {
        case .udf:
            return [
                "View/\(moduleName)Container.swift": "ModuleContainer",
                "View/\(moduleName)Component.swift": "ModuleComponent",
                "View/\(moduleName)Routing.swift": "ModuleRouting",
                "State/\(moduleName)Flow.swift": "ModuleFlow",
                "State/\(moduleName)Form.swift": "ModuleForm",
                "\(moduleName)Middleware.swift": "ModuleMiddleware"
            ]
        case .bindable:
            return [
                "View/\(moduleName)Container.swift": "BindableModuleContainer",
                "View/\(moduleName)Component.swift": "BindableModuleComponent",
                "View/\(moduleName)Routing.swift": "BindableModuleRouting",
                "State/\(moduleName)Flow.swift": "BindableModuleFlow",
                "State/\(moduleName)Form.swift": "BindableModuleForm",
                "\(moduleName)Middleware.swift": "BindableModuleMiddleware"
            ]
        case .paginated:
            return [
                "": ""
            ]
        case .storage:
            return [
                "": ""
            ]
        }
    }
}
