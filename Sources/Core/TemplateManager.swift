//
//  TemplateManager.swift
//  UDFGen
//
//  Created by Eugene Ned on 31.01.2025.
//

import Foundation

public final class TemplateManager {
    private let templatesPath: URL
    
    public init(packagePath: URL, templateType: TemplateType) {
        self.templatesPath = packagePath
            .appendingPathComponent("Templates")
            .appendingPathComponent(templateType.directoryName)
    }
    
    public func renderTemplate(named templateName: String, with moduleName: String) throws -> String {
        let templateFileURL = templatesPath.appendingPathComponent("\(templateName).swift")
        guard FileManager.default.fileExists(atPath: templateFileURL.path) else {
            throw TemplateError.templateNotFound("Template \(templateName) not found in \(templatesPath.path).")
        }
        
        let templateContent = try String(contentsOf: templateFileURL, encoding: .utf8)
        return templateContent
            .replacingOccurrences(of: "{{moduleName}}", with: moduleName)
            .replacingOccurrences(of: "{{moduleNameLovercased}}", with: moduleName.uncapitalized)
    }
}

