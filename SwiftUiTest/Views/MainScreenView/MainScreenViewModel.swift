//
//  MainScreenViewModel.swift
//  SwiftUiTest
//
//  Created by Евгений Сергеев on 11.04.2025.
//

import SwiftUI
import Photos

final class MainScreenViewModel: ObservableObject {
    @Published var showingFullScreenPhoto: PhotoAsset?
    @Published var authorizationStatus: PHAuthorizationStatus = .notDetermined
    
    @Published var showingSuccessScreen = false
    @Published var showingAuthorizationErrorScreen = false

    func checkAuthorization(authorizedCompletion: (() -> Void)?, deniedCompletion: (() -> Void)? = nil) {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        authorizationStatus = status
        
        switch status {
            
        case .notDetermined:
            requestAuthorization() {
                authorizedCompletion?()
            }
        case .authorized:
            authorizedCompletion?()
        default:
            deniedCompletion?()
        }
    }
    
    func requestAuthorization(completion: (() -> Void)?) {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            DispatchQueue.main.async {
                self.authorizationStatus = status
                if status == .authorized {
                    completion?()
                }
            }
        }
    }
}
