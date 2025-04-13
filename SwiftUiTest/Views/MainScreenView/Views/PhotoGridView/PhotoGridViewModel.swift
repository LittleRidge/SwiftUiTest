//
//  PhotoGridViewModel.swift
//  SwiftUiTest
//
//  Created by Евгений Сергеев on 11.04.2025.
//

import Foundation

final class PhotoGridViewModel: ObservableObject {
    func shouldSelectAll(for group: PhotoGroup) -> Bool {
        group.photos.contains { !$0.isSelected }
    }
    
    func toggleSelection(for group: PhotoGroup) -> PhotoGroup {
        let shouldSelect = shouldSelectAll(for: group)
        
        var togledGroup = group
        
        for i in 0..<togledGroup.photos.count {
            togledGroup.photos[i].isSelected = shouldSelect
        }
        
        return togledGroup
    }
}
