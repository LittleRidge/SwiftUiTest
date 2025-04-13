//
//  PhotoManager.swift
//  SwiftUiTest
//
//  Created by Евгений Сергеев on 11.04.2025.
//

import SwiftUI
import Photos
import Vision

final class PhotoManager: ObservableObject {
    static let shared = PhotoManager()
    
    @Published var photoGroups: [PhotoGroup] = []
    @Published var isLoading = false
    @Published var totalFreedSpace: Int64 = 0
    @Published var deletedPhotosCount = 0
    @Published var selectedPhotosCount = 0
    
    private let imageManager = PHCachingImageManager()
    private let similarityThreshold: Float = 0.5 // Порог схожести изображений (0-1)
    
    var totalPhotosCount: Int {
        photoGroups.reduce(0) { $0 + $1.photos.count }
    }
    
    func loadPhotos() {
        isLoading = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            
            var assets: [PhotoAsset] = []
            for i in 0..<allPhotos.count {
                let asset = allPhotos[i]
                assets.append(PhotoAsset(asset: asset))
            }
            
            self.groupSimilarPhotos(assets: assets) { groups in
                DispatchQueue.main.async {
                    self.photoGroups = groups
                    self.isLoading = false
                    self.loadThumbnails()
                }
            }
        }
    }
    
    private func groupSimilarPhotos(assets: [PhotoAsset], completion: @escaping ([PhotoGroup]) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            var featureVectors = [String: VNFeaturePrintObservation]()
            let dispatchGroup = DispatchGroup()
            let serialQueue = DispatchQueue(label: "featureExtractionQueue")
            
            for asset in assets {
                dispatchGroup.enter()
                self.extractFeatureVector(for: asset.asset) { observation in
                    serialQueue.async {
                        if let observation = observation {
                            featureVectors[asset.id] = observation
                        }
                        dispatchGroup.leave()
                    }
                }
            }
            
            dispatchGroup.notify(queue: .global(qos: .userInitiated)) {
                var groups = [PhotoGroup]()
                var processedIDs = Set<String>()
                
                for (id, featureVector) in featureVectors {
                    guard !processedIDs.contains(id) else { continue }
                    
                    var similarPhotos = [PhotoAsset]()
                    let currentAsset = assets.first { $0.id == id }!
                    similarPhotos.append(currentAsset)
                    processedIDs.insert(id)
                    
                    for (otherID, otherFeatureVector) in featureVectors {
                        guard id != otherID, !processedIDs.contains(otherID) else { continue }
                        
                        do {
                            var distance: Float = 0
                            try featureVector.computeDistance(&distance, to: otherFeatureVector)
                            
                            let similarity = 1 - distance
                            if similarity >= self.similarityThreshold {
                                let otherAsset = assets.first { $0.id == otherID }!
                                similarPhotos.append(otherAsset)
                                processedIDs.insert(otherID)
                            }
                        } catch {
                            print("Error computing distance: \(error)")
                        }
                    }
                    
                    if similarPhotos.count >= 2 {
                        groups.append(PhotoGroup(photos: similarPhotos))
                    }
                }
                
                for asset in assets {
                    if !processedIDs.contains(asset.id) {
                        groups.append(PhotoGroup(photos: [asset]))
                    }
                }
                
                completion(groups)
            }
        }
    }
    
    private func extractFeatureVector(for asset: PHAsset, completion: @escaping (VNFeaturePrintObservation?) -> Void) {
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = false
        requestOptions.deliveryMode = .highQualityFormat
        requestOptions.isNetworkAccessAllowed = true
        
        imageManager.requestImageDataAndOrientation(for: asset, options: requestOptions) { data, _, _, _ in
            guard let data = data, let image = UIImage(data: data)?.cgImage else {
                completion(nil)
                return
            }
            
            let request = VNGenerateImageFeaturePrintRequest()
            let requestHandler = VNImageRequestHandler(cgImage: image, options: [:])
            
            do {
                try requestHandler.perform([request])
                completion(request.results?.first as? VNFeaturePrintObservation)
            } catch {
                print("Error extracting feature vector: \(error)")
                completion(nil)
            }
        }
    }
    
    func loadThumbnails() {
        for groupIndex in 0..<photoGroups.count {
            for photoIndex in 0..<photoGroups[groupIndex].photos.count {
                let asset = photoGroups[groupIndex].photos[photoIndex].asset
                let options = PHImageRequestOptions()
                options.deliveryMode = .opportunistic
                options.isNetworkAccessAllowed = true
                
                let size = CGSize(width: 200.0, height: 200.0)
                imageManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: options) { image, _ in
                    DispatchQueue.main.async {
                        if let image = image {
                            self.photoGroups[groupIndex].photos[photoIndex].thumbnail = image
                        }
                    }
                }
            }
        }
    }
    
    func deleteSelectedPhotos(completion: @escaping (Int64) -> Void) {
        var assetsToDelete: [PHAsset] = []
        var totalSize: Int64 = 0
        deletedPhotosCount = 0
        
        for groupIndex in 0..<photoGroups.count {
            for photoIndex in 0..<photoGroups[groupIndex].photos.count {
                if photoGroups[groupIndex].photos[photoIndex].isSelected {
                    let asset = photoGroups[groupIndex].photos[photoIndex].asset
                    assetsToDelete.append(asset)
                    totalSize += Int64(asset.pixelWidth * asset.pixelHeight)
                    deletedPhotosCount += 1
                }
            }
        }
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.deleteAssets(assetsToDelete as NSFastEnumeration)
        }) { success, _ in
            DispatchQueue.main.async {
                if success {
                    self.totalFreedSpace = totalSize
                    
                    var updatedGroups = self.photoGroups
                    for groupIndex in 0..<updatedGroups.count {
                        updatedGroups[groupIndex].photos.removeAll { $0.isSelected }
                    }
                    
                    updatedGroups.removeAll { $0.photos.isEmpty }
                    
                    self.photoGroups = updatedGroups
                    
                    completion(totalSize)
                }
            }
        }
    }
    
    func toggleSelection(for photoID: String) {
        for groupIndex in 0..<photoGroups.count {
            for photoIndex in 0..<photoGroups[groupIndex].photos.count {
                var photo = photoGroups[groupIndex].photos[photoIndex]
                
                if photo.id == photoID {
                    photo.isSelected.toggle()
                    photoGroups[groupIndex].photos[photoIndex] = photo
                    selectedPhotosCounter()
                    return
                }
            }
        }
    }
    
    func changeToggledGroup(_ group: PhotoGroup) {
        if let index = photoGroups.firstIndex(where: { $0.id == group.id }) {
            photoGroups[index] = group
        }
        
        selectedPhotosCounter()
    }
    
    func selectedPhotosCounter() {
        var count = 0
        for group in photoGroups {
            count += group.photos.filter { $0.isSelected }.count
        }
        selectedPhotosCount = count
    }
    
    func getSelectedPhotos() -> [PhotoAsset] {
        var selected: [PhotoAsset] = []
        for group in photoGroups {
            selected.append(contentsOf: group.photos.filter { $0.isSelected })
        }
        return selected
    }
}

struct PhotoGroup: Identifiable {
    let id = UUID()
    var photos: [PhotoAsset]
}

struct PhotoAsset: Identifiable {
    let asset: PHAsset
    let id: String
    var thumbnail: UIImage?
    var isSelected: Bool = false

    init(asset: PHAsset) {
        self.asset = asset
        self.id = asset.localIdentifier
    }
}
