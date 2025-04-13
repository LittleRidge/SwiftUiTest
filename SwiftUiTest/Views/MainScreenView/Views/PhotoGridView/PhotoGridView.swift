//
//  PhotoGridView.swift
//  SwiftUiTest
//
//  Created by Евгений Сергеев on 11.04.2025.
//

import SwiftUI

struct PhotoGridView: View {
    @EnvironmentObject var photoManager: PhotoManager

    @Binding var showingFullScreenPhoto: PhotoAsset?
    
    @StateObject var viewModel = PhotoGridViewModel()
        
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20.0) {
                ForEach(photoManager.photoGroups) { group in
                    VStack(alignment: .leading, spacing: 8.0) {
                        if !group.photos.isEmpty {
                            HStack {
                                Text(group.title)
                                    .font(.system(size: 24.0, weight: .bold))
                                
                                Spacer()
                                
                                Button(action: {
                                    withAnimation {
                                        photoManager.changeToggledGroup(viewModel.toggleSelection(for: group))
                                    }
                                }) {
                                    Text(viewModel.shouldSelectAll(for: group) ? "Select All" : "Deselect All")
                                        .font(.system(size: 16.0, weight: .regular))
                                        .foregroundColor(Constants.AppColors.lightBlue.color)
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10.0) {
                                ForEach(group.photos) { photo in
                                    PhotoThumbnailView(photo: photo)
                                        .onTapGesture {
                                            showingFullScreenPhoto = photo
                                        }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .animation(.default, value: group.photos.count)
                }
            }
            .padding(.vertical)
        }
        .refreshable {
            withAnimation {
                photoManager.loadPhotos()
            }
        }
        .background(Constants.AppColors.white.color)
        .clipShape(
            .rect(
                topLeadingRadius: 20.0,
                bottomLeadingRadius: 16.0,
                bottomTrailingRadius: 16.0,
                topTrailingRadius: 20.0
            )
        )
        .ignoresSafeArea(.all)
    }
}

private extension PhotoGroup {
    var title: String {
        "\(photos.count) Similar"
    }
}
