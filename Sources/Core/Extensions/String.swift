//
//  String.swift
//  UDFGenCore
//
//  Created by Eugene Ned on 04.02.2025.
//

import Foundation

extension String {
    var uncapitalized: String {
        guard let first = first else { return self }
        return first.lowercased() + dropFirst()
    }
}
