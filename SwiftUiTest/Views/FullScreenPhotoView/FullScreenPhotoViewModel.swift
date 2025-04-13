//
//  FullScreenPhotoViewModel.swift
//  SwiftUiTest
//
//  Created by Евгений Сергеев on 11.04.2025.
//

import SwiftUI
import Photos

final class FullScreenPhotoViewModel: ObservableObject {
    let photo: PhotoAsset
    @Published var image: UIImage?
    
    init(photo: PhotoAsset) {
        self.photo = photo
    }
    
    func loadFullImage() {
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        
        PHImageManager.default().requestImage(
            for: photo.asset,
            targetSize: PHImageManagerMaximumSize,
            contentMode: .aspectFit,
            options: options
        ) { img, _ in
            self.image = img
        }
    }
}
