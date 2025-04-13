//
//  FullScreenPhotoView.swift
//  SwiftUiTest
//
//  Created by Евгений Сергеев on 10.04.2025.
//

import SwiftUI

struct FullScreenPhotoView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel: FullScreenPhotoViewModel
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .transition(.opacity)
            } else {
                ProgressView()
            }
        }
        .onAppear {
            viewModel.loadFullImage()
        }
        .onTapGesture {
            dismiss()
        }
        .ignoresSafeArea(.all)
    }
}
