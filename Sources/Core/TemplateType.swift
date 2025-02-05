//
//  TemplateType.swift
//  UDFGen
//
//  Created by Eugene Ned on 31.01.2025.
//

import Foundation

public enum TemplateType: String, Codable, CaseIterable {
    case udf = "UDF"
    case bindable = "Bindable"
    case paginated = "Paginated"
    case storage = "Storage"
    
    public var directoryName: String {
        self.rawValue
    }
    
    public var description: String {
        switch self {
        case .udf: "UDF Module"
        case .bindable: "Bindable Module"
        case .paginated: "Paginated Module"
        case .storage: "Storage Module"
        }
    }
}
