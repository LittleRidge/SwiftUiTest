//
//  PhotoThumbnailView.swift
//  SwiftUiTest
//
//  Created by Евгений Сергеев on 11.04.2025.
//

import SwiftUI

struct PhotoThumbnailView: View {
    let photo: PhotoAsset
    @EnvironmentObject var photoManager: PhotoManager
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            if let thumbnail = photo.thumbnail {
                Image(uiImage: thumbnail)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 183.0, height: 215.0)
                    .clipShape(RoundedRectangle(cornerRadius: 14.0))
                    .contentShape(Rectangle())
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 100.0, height: 100.0)
                    .clipShape(RoundedRectangle(cornerRadius: 14.0))
            }
            
            Button(action: {
                photoManager.toggleSelection(for: photo.id)
            }) {
                RoundedRectangle(cornerRadius: 12.0)
                    .fill(photo.isSelected ? Constants.AppColors.green.color : .clear)
                    .frame(width: 30.0, height: 30.0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12.0)
                            .stroke(photo.isSelected ? .clear : Constants.AppColors.white.color, lineWidth: 3)
                    )
                    .overlay(alignment: .center) {
                        Image(systemName: "checkmark")
                            .resizable()
                            .font(Font.title.weight(.bold))
                            .foregroundColor(photo.isSelected ? Constants.AppColors.white.color : .clear)
                            .frame(width: 15.0, height: 11.0)
                    }
                    .offset(x: -8.0, y: -10.0)
            }
        }
    }
}
