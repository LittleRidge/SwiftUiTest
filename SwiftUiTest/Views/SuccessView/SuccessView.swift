//
//  SuccessView.swift
//  SwiftUiTest
//
//  Created by Евгений Сергеев on 10.04.2025.
//

import SwiftUI

struct SuccessView: View {
    @EnvironmentObject var photoManager: PhotoManager
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel: SuccessViewModel
    var deleteCompletion: (() -> Void)?
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                Image(.succesMain)
                    .resizable()
                    .frame(width: 230.0, height: 228.0)
                
                Text("Congratulations!")
                    .font(.system(size: 36.0, weight: .bold))
            }
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 52.0) {
                HStack() {
                    ZStack(alignment: .center) {
                        Image(.succesStar)
                            .resizable()
                            .frame(width: 37.0, height: 40.0)
                    }
                    .frame(width: 54.0, height: 54.0)
                    
                    VStack(spacing: 0) {
                        Text("You have deleted")
                            .frame(alignment: .leading)
                            .font(.system(size: 20.0, weight: .regular))
                        
                        HStack {
                            Text("\(photoManager.deletedPhotosCount) Photos")
                                .font(.system(size: 20.0, weight: .bold))
                                .foregroundColor(Constants.AppColors.darkBlue.color)
                            Text("(\(viewModel.formattedFreedSpace()))")
                                .font(.system(size: 20.0, weight: .regular))
                        }
                    }
                }
                
                HStack() {
                    ZStack(alignment: .center) {
                        Image(.succesSandClock)
                            .resizable()
                            .frame(width: 24.0, height: 40.0)
                    }
                    .frame(width: 54.0, height: 54.0)
                
                    VStack(alignment: .leading ,spacing: 0) {
                        HStack {
                            Text("Saved")
                                .font(.system(size: 20.0, weight: .regular))
                            Text("\(Int.random(in: 10...1000)) Minutes")
                                .font(.system(size: 20.0, weight: .bold))
                                .foregroundColor(Constants.AppColors.darkBlue.color)
                        }
                        Text("using Cleanup")
                            .font(.system(size: 20.0, weight: .regular))
                    }
                }
            }
            
            Spacer()
            
            Text("Review all your videos. Sort the by size or date. See the ones that occupy the most space.")
                .font(.system(size: 16.0, weight: .regular))
                .foregroundColor(Constants.AppColors.gray.color)
                .padding(.horizontal, 15.0)
            
            Spacer()
            
            Button(action: {
                deleteCompletion?()
                dismiss()
            }) {
                Text("Great")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Constants.AppColors.darkBlue.color)
                    .foregroundColor(Constants.AppColors.white.color)
                    .cornerRadius(24)
            }
            .frame(width: 345.0, height: 60.0)
        }
        .padding(EdgeInsets(top: 0.0, leading: 17.0, bottom: 60.0, trailing: 17.0))
        .multilineTextAlignment(.center)
    }
}
