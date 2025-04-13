//
//  DeleteButtonView.swift
//  SwiftUiTest
//
//  Created by Евгений Сергеев on 11.04.2025.
//

import SwiftUI

struct DeleteButtonView: View {
    let deletedItemCount: Int
    var action: (() -> Void)?
    
    var body: some View {
        Button {
            action?()
        } label: {
            HStack(alignment: .center) {
                Image(.delete1)
                    .resizable()
                    .font(Font.title.weight(.bold))
                    .foregroundColor(Constants.AppColors.white.color)
                    .frame(width: 14.0, height: 18.0)
                
                Text("Delete \(deletedItemCount) similars")
                    .font(.system(size: 18.0, weight: .semibold))
                    .foregroundColor(Constants.AppColors.white.color)
            }
            .frame(width: UIScreen.main.bounds.width - 48.0, height: 60.0)
            .background(Constants.AppColors.darkBlue.color)
            .cornerRadius(30)
        }
        .buttonStyle(PlainButtonStyle())
        .compositingGroup()
        .shadow(color: .black.opacity(0.1), radius: 10.0, x: 0, y: 4.0)
    }
}
