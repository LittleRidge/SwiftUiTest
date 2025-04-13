//
//  AuthorizationView.swift
//  SwiftUiTest
//
//  Created by Евгений Сергеев on 11.04.2025.
//

import SwiftUI

import SwiftUI
import Photos

struct AuthorizationView: View {
    var requestCompletion: (() -> Void)?

    var body: some View {
        VStack(spacing: 20.0) {
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 60.0))
                .foregroundColor(Constants.AppColors.lightBlue.color)
            
            Text("Access to photos")
                .font(.title)
                .bold()
            
            Text("To search for similar photos, you need to provide access to your gallery.")
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40.0)
            
            Button {
                requestCompletion?()
            } label: {
                Text("Allow access")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Constants.AppColors.lightBlue.color)
                    .foregroundColor(Constants.AppColors.white.color)
                    .cornerRadius(10.0)
            }
            .padding(.horizontal, 40.0)
            .padding(.top, 20.0)
        }
    }
}
