//
//  SuccessViewModel.swift
//  SwiftUiTest
//
//  Created by Евгений Сергеев on 11.04.2025.
//

import SwiftUI

final class SuccessViewModel: ObservableObject{
    let freedSpace: Int64
    
    init(freedSpace: Int64) {
        self.freedSpace = freedSpace
    }

    func formattedFreedSpace() -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useGB, .useMB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: freedSpace)
    }
}
