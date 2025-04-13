//
//  ContentView.swift
//  SwiftUiTest
//
//  Created by Евгений Сергеев on 26.09.2024.
//

import SwiftUI
import Photos

struct MainScreenView: View {
    @EnvironmentObject var photoManager: PhotoManager
    
    @StateObject var viewModel = MainScreenViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                if viewModel.authorizationStatus == .authorized {
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                Spacer()
                                Text("Similar")
                                    .font(.system(size: 28.0, weight: .bold))
                                    .foregroundColor(Constants.AppColors.white.color)
                                
                                Text("\(photoManager.totalPhotosCount) photos • \(photoManager.selectedPhotosCount) selected")
                                    .font(.system(size: 14.0, weight: .regular))
                                    .foregroundColor(Constants.AppColors.white.color)
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 15.0)
                        .frame(height: 124.0)
                        
                        PhotoGridView(showingFullScreenPhoto: $viewModel.showingFullScreenPhoto)
                            .overlay {
                                ProgressView()
                                    .opacity(photoManager.isLoading ? 1 : 0)
                                    .progressViewStyle(CircularProgressViewStyle(tint: Constants.AppColors.lightBlue.color))
                                    .scaleEffect(1.5)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(.clear)
                            }
                    }
                } else {
                    AuthorizationView() {
                        viewModel.checkAuthorization(
                            authorizedCompletion: {
                                photoManager.loadPhotos()
                            },
                            deniedCompletion: {
                                viewModel.showingAuthorizationErrorScreen = true
                            })
                    }
                }
                
                DeleteButtonView(
                    deletedItemCount: photoManager.selectedPhotosCount,
                    action: {
                        photoManager.deleteSelectedPhotos { _ in
                            viewModel.showingSuccessScreen = true
                        }
                    })
                .opacity(photoManager.selectedPhotosCount > 0 ? 1 : 0)
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .offset(y: -35.0)
            }
            .background(viewModel.authorizationStatus == .authorized ? Constants.AppColors.lightBlue.color : Constants.AppColors.white.color)
        }
        .ignoresSafeArea(.all)
        .fullScreenCover(item: $viewModel.showingFullScreenPhoto) { photo in
            FullScreenPhotoView(viewModel: FullScreenPhotoViewModel(photo: photo))
        }
        .fullScreenCover(isPresented: $viewModel.showingSuccessScreen) {
            SuccessView(
                viewModel: SuccessViewModel(freedSpace: photoManager.totalFreedSpace),
                deleteCompletion: {
                    photoManager.selectedPhotosCounter()
                })
        }
        .alert(isPresented: $viewModel.showingAuthorizationErrorScreen) {
            Alert (title: Text("Gallery accessing error"),
                   message: Text("To use the application, go to settings and give permission to access the device's media files."),
                   primaryButton: .default(Text("Settings"), action: {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }),
                   secondaryButton: .default(Text("Cancel")))
        }

        .onAppear() {
            viewModel.checkAuthorization() {
                photoManager.loadPhotos()
            }
        }
    }
}
