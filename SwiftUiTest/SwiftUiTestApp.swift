//
//  SwiftUiTestApp.swift
//  SwiftUiTest
//
//  Created by Евгений Сергеев on 26.09.2024.
//

import SwiftUI
import Photos

@main
struct PhotoDeduplicatorApp: App {
    var body: some Scene {
        WindowGroup {
            MainScreenView()
                .environmentObject(PhotoManager.shared)
        }
    }
}
